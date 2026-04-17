// ignore_for_file: lines_longer_than_80_chars

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import 'package:calorie_tracker/core/utils/seed_key.dart';
import 'package:calorie_tracker/data/database/app_database.dart';
import 'package:calorie_tracker/data/seed/db_seeder.dart';

/// Tests for [DbSeeder.reconcileFoodsFromRawDb] — the additive, idempotent
/// reconciliation that runs on every launch via `beforeOpen`.
///
/// Strategy: we don't go through [DbSeeder.reconcileInto] because that path
/// reads an asset via path_provider + rootBundle, which requires a Flutter
/// binding. Instead we build an in-memory raw sqlite3 database that mimics
/// the asset schema and hand it to the testable `@visibleForTesting` entry
/// point. This covers all the reconciliation logic that isn't pure I/O.
///
/// Architectural invariants under test (see `.claude/decisions/database-schema.md`):
///   * §2 — short-circuits when the device is already at or above target
///   * §3 — matches pre-existing rows by `seed_key`, never by `(name, brand)`
///   * §4 — never modifies existing rows, never touches `is_custom = 1` rows
///   * §7 — custom rows (seed_key = NULL) cannot collide with an asset key

/// Creates an in-memory raw sqlite3 DB matching the shape of `assets/foods.db`
/// — enough columns for [DbSeeder._companionFromRow] to work. Tests populate
/// it via [_insertAssetRow].
raw.Database _makeAssetDb() {
  final db = raw.sqlite3.openInMemory();
  db.execute('''
    CREATE TABLE foods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      brand TEXT,
      category TEXT NOT NULL,
      calories_per_100g REAL NOT NULL,
      protein_per_100g REAL,
      carbs_per_100g REAL,
      fat_per_100g REAL,
      fiber_per_100g REAL,
      sugar_per_100g REAL,
      sodium_per_100mg REAL,
      default_serving_g REAL,
      serving_description TEXT,
      is_gluten_free INTEGER,
      gluten_status TEXT,
      is_custom INTEGER,
      seed_key TEXT
    )
  ''');
  return db;
}

/// Asset DB variant WITHOUT the `seed_key` column — used to verify the
/// fallback path for legacy assets shipped before Session 1.
raw.Database _makeLegacyAssetDb() {
  final db = raw.sqlite3.openInMemory();
  db.execute('''
    CREATE TABLE foods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      brand TEXT,
      category TEXT NOT NULL,
      calories_per_100g REAL NOT NULL,
      gluten_status TEXT,
      is_custom INTEGER
    )
  ''');
  return db;
}

void _insertAssetRow(
  raw.Database asset, {
  required String name,
  String? brand,
  String category = 'general',
  double caloriesPer100g = 100,
  String glutenStatus = 'gluten_free',
  int isCustom = 0,
  String? seedKey,
}) {
  asset.execute(
    'INSERT INTO foods (name, brand, category, calories_per_100g, gluten_status, is_custom, seed_key) '
    'VALUES (?, ?, ?, ?, ?, ?, ?)',
    [name, brand, category, caloriesPer100g, glutenStatus, isCustom, seedKey],
  );
}

void _insertLegacyAssetRow(
  raw.Database asset, {
  required String name,
  String? brand,
  String category = 'general',
  double caloriesPer100g = 100,
  String glutenStatus = 'gluten_free',
}) {
  asset.execute(
    'INSERT INTO foods (name, brand, category, calories_per_100g, gluten_status, is_custom) '
    'VALUES (?, ?, ?, ?, ?, 0)',
    [name, brand, category, caloriesPer100g, glutenStatus],
  );
}

/// Inserts a pre-existing seeded row directly into the live foods table,
/// simulating what would be on-device after an earlier seed.
Future<int> _insertLiveSeededFood(
  AppDatabase db, {
  required String name,
  String? brand,
  required String seedKey,
  String glutenStatus = 'gluten_free',
}) {
  return db.into(db.foods).insert(
        FoodsCompanion.insert(
          name: name,
          brand: Value(brand),
          category: 'general',
          caloriesPer100g: 100,
          glutenStatus: Value(glutenStatus),
          isCustom: const Value(0),
          seedKey: Value(seedKey),
        ),
      );
}

/// Inserts a user-entered custom row (seed_key = NULL) into the live table.
Future<int> _insertLiveCustomFood(
  AppDatabase db, {
  required String name,
  String? brand,
  String glutenStatus = 'unknown',
}) {
  return db.into(db.foods).insert(
        FoodsCompanion.insert(
          name: name,
          brand: Value(brand),
          category: 'general',
          caloriesPer100g: 100,
          glutenStatus: Value(glutenStatus),
          isCustom: const Value(1),
          // seedKey intentionally omitted → NULL
        ),
      );
}

void main() {
  late AppDatabase db;
  late raw.Database asset;

  setUp(() {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(),
      skipSeeding: true,
    );
    asset = _makeAssetDb();
  });

  tearDown(() async {
    asset.dispose();
    await db.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Short-circuit behavior
  // ═══════════════════════════════════════════════════════════════════════════

  group('short-circuit', () {
    test('does nothing when device version equals target', () async {
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 2);
      _insertAssetRow(asset, name: 'New Food', seedKey: 'new_food__generic');

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      expect(report.skippedByShortCircuit, isTrue);
      expect(report.inserted, equals(0));
      final live = await db.select(db.foods).get();
      expect(live, isEmpty, reason: 'no inserts when short-circuit fires');
    });

    test('does nothing when device version is ahead of target', () async {
      // Shouldn't happen in practice, but guard against accidental rollback:
      // a downgraded build must never clobber a newer device's metadata.
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 5);
      _insertAssetRow(asset, name: 'Old Food', seedKey: 'old_food__generic');

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      expect(report.skippedByShortCircuit, isTrue);
      final stored = await db.metadataDao.getInt(DbSeeder.seedVersionKey);
      expect(stored, equals(5),
          reason: 'short-circuit must not overwrite a higher version');
    });

    test('proceeds when device has no seed_version metadata (treated as 0)',
        () async {
      // No metadata row — simulates a buggy install that missed the
      // bookkeeping. Reconcile should treat it as "behind everything" and
      // fully populate from the asset.
      _insertAssetRow(asset, name: 'Food A', seedKey: 'food_a__generic');
      _insertAssetRow(asset, name: 'Food B', seedKey: 'food_b__generic');

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 1,
      );

      expect(report.skippedByShortCircuit, isFalse);
      expect(report.inserted, equals(2));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Additive inserts
  // ═══════════════════════════════════════════════════════════════════════════

  group('additive inserts', () {
    test(
        'inserts only rows whose seed_key is not already on-device; existing seeded row is untouched',
        () async {
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
      final existingId = await _insertLiveSeededFood(
        db,
        name: 'Apple',
        seedKey: 'apple__generic',
      );
      _insertAssetRow(asset, name: 'Apple', seedKey: 'apple__generic');
      _insertAssetRow(asset, name: 'Banana', seedKey: 'banana__generic');
      _insertAssetRow(asset, name: 'Cherry', seedKey: 'cherry__generic');

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      expect(report.inserted, equals(2));
      expect(report.skipped, equals(1));

      final live = await db.select(db.foods).get();
      expect(live, hasLength(3));
      expect(live.map((f) => f.seedKey).toSet(),
          equals({'apple__generic', 'banana__generic', 'cherry__generic'}));

      // The existing Apple row must still have its original id — an update
      // disguised as an insert would either collide on primary key or
      // allocate a new id. Neither is acceptable.
      final apple =
          live.singleWhere((f) => f.seedKey == 'apple__generic');
      expect(apple.id, equals(existingId));
    });

    test('writes seed_version = target only after successful insert batch',
        () async {
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
      _insertAssetRow(asset, name: 'Food', seedKey: 'food__generic');

      await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      final stored = await db.metadataDao.getInt(DbSeeder.seedVersionKey);
      expect(stored, equals(2));
    });

    test(
        'inserts work even when asset rows have zero new seed_keys — version still bumps',
        () async {
      // Scenario: seed content didn't actually grow, but the version did.
      // Valid only for release-check disciplined builds, but the reconciler
      // must handle it without crashing — version stamp, zero inserts.
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
      await _insertLiveSeededFood(
        db,
        name: 'Apple',
        seedKey: 'apple__generic',
      );
      _insertAssetRow(asset, name: 'Apple', seedKey: 'apple__generic');

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      expect(report.inserted, equals(0));
      expect(report.skipped, equals(1));
      final stored = await db.metadataDao.getInt(DbSeeder.seedVersionKey);
      expect(stored, equals(2));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Custom-row safety
  // ═══════════════════════════════════════════════════════════════════════════

  group('custom rows (is_custom = 1) are never touched', () {
    test(
        'custom row with same display name as an asset row does NOT block the asset insert',
        () async {
      // User created a custom "Apple" before the reconciler shipped. The
      // asset ships its own "Apple" with seed_key. These are different
      // identities — the reconciler must insert the seeded one and leave
      // the custom one alone.
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
      final customId = await _insertLiveCustomFood(
        db,
        name: 'Apple',
        glutenStatus: 'unknown',
      );
      _insertAssetRow(
        asset,
        name: 'Apple',
        seedKey: 'apple__generic',
        glutenStatus: 'gluten_free',
      );

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      expect(report.inserted, equals(1));

      final live = await db.select(db.foods).get();
      expect(live, hasLength(2));

      final custom = live.singleWhere((f) => f.id == customId);
      expect(custom.isCustom, equals(1));
      expect(custom.seedKey, isNull,
          reason: 'custom row must never acquire a seed_key');
      expect(custom.glutenStatus, equals('unknown'),
          reason: 'custom row must not be mutated by reconciliation');

      final seeded =
          live.singleWhere((f) => f.seedKey == 'apple__generic');
      expect(seeded.isCustom, equals(0));
      expect(seeded.glutenStatus, equals('gluten_free'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Idempotency — calling twice is safe
  // ═══════════════════════════════════════════════════════════════════════════

  group('idempotency', () {
    test('running reconcile twice with the same asset produces no duplicates',
        () async {
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
      _insertAssetRow(asset, name: 'Food A', seedKey: 'food_a__generic');
      _insertAssetRow(asset, name: 'Food B', seedKey: 'food_b__generic');

      final first = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );
      expect(first.inserted, equals(2));

      // Second pass — device is now at v2, short-circuit should fire.
      final second = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );
      expect(second.skippedByShortCircuit, isTrue);
      expect(second.inserted, equals(0));

      final live = await db.select(db.foods).get();
      expect(live, hasLength(2), reason: 'no duplicates on second run');
    });

    test(
        'an asset with duplicate seed_keys inserts each key once, not per occurrence',
        () async {
      // Defensive: if the Python tool ever emits duplicates, we don't want
      // to poison the live table.
      await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
      _insertAssetRow(asset, name: 'Food A v1', seedKey: 'food_a__generic');
      _insertAssetRow(asset, name: 'Food A v2', seedKey: 'food_a__generic');

      final report = await DbSeeder.reconcileFoodsFromRawDb(
        db,
        asset,
        targetSeedVersion: 2,
      );

      expect(report.inserted, equals(1));
      expect(report.skipped, equals(1));
      final live = await db.select(db.foods).get();
      expect(live, hasLength(1));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Legacy asset compatibility
  // ═══════════════════════════════════════════════════════════════════════════

  group('legacy asset (no seed_key column)', () {
    test('falls back to computed seed_key via makeSeedKey(name, brand)',
        () async {
      final legacyAsset = _makeLegacyAssetDb();
      try {
        await db.metadataDao.setInt(DbSeeder.seedVersionKey, 1);
        _insertLegacyAssetRow(legacyAsset, name: 'Oat Milk', brand: 'Oatly');
        _insertLegacyAssetRow(legacyAsset, name: 'Oat Milk', brand: null);

        final report = await DbSeeder.reconcileFoodsFromRawDb(
          db,
          legacyAsset,
          targetSeedVersion: 2,
        );

        expect(report.inserted, equals(2));

        final live = await db.select(db.foods).get();
        final keys = live.map((f) => f.seedKey).toSet();
        expect(
          keys,
          equals({
            makeSeedKey('Oat Milk', 'Oatly'),
            makeSeedKey('Oat Milk', null),
          }),
        );
      } finally {
        legacyAsset.dispose();
      }
    });
  });
}
