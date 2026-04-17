import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import '../../core/utils/seed_key.dart';
import '../database/app_database.dart';

/// Seeds foods and exercises from bundled asset databases into the main
/// [AppDatabase], and reconciles newly-shipped seed rows into existing
/// installs.
///
/// Two entry points — they must stay logically separate:
///   * [seedInto]       — runs ONCE, from [MigrationStrategy.onCreate].
///                        Fills an empty DB from the asset catalogs.
///   * [reconcileInto]  — runs on every launch from
///                        [MigrationStrategy.beforeOpen]. Idempotent.
///                        Inserts only rows whose [seedKey] is not already
///                        present; never modifies user or existing seeded rows.
///
/// See also: [currentSeedVersion] / [seedVersionKey] — the mechanism that
/// lets future releases ship additional foods without overwriting user data.
/// Architecture rationale lives in `.claude/decisions/database-schema.md`.
class DbSeeder {
  DbSeeder._();

  static const _foodsAsset = 'assets/foods.db';
  static const _exercisesAsset = 'assets/exercises.db';

  /// Key used in the `metadata` table to track which seed version is
  /// installed on the device.
  static const String seedVersionKey = 'seed_version';

  /// Version of the seed data bundled in this build of the app. Bump this
  /// every release that ships new or changed foods/exercises in assets/*.db.
  ///
  /// The reconciliation flow compares this to the value stored in
  /// `metadata.seed_version` on the device:
  ///   - Equal or lower    → nothing to do
  ///   - Device < this     → read asset DB, insert only missing seed_keys
  ///
  /// DO NOT bump without regenerating assets/foods.db. DO NOT regenerate
  /// assets/foods.db without bumping. (See ADR §2.)
  static const int currentSeedVersion = 2;

  /// Called from [AppDatabase.migration] onCreate — reads the bundled asset DBs
  /// and inserts all rows into the already-created Drift tables.
  static Future<void> seedInto(AppDatabase db) async {
    await _seedFoods(db);
    await _seedExercises(db);
  }

  /// Called from [AppDatabase.migration] beforeOpen on every launch after a
  /// fresh install or upgrade.
  ///
  /// Behavior:
  ///   1. Read `metadata.seed_version` (defaults to 0 if missing — treats
  ///      the device as older than anything ever shipped).
  ///   2. If device version >= [currentSeedVersion], return immediately.
  ///      No asset I/O, no binding required beyond one DAO read.
  ///   3. Otherwise, open the bundled foods asset, insert rows whose
  ///      [seedKey] is not already in the live table, and stamp the new
  ///      device version — all inside a single transaction.
  ///
  /// Only handles foods. Exercises don't yet carry a seed_key column, so
  /// there's no safe way to reconcile them additively. When that changes,
  /// add the matching logic here.
  ///
  /// Never touches rows with `is_custom = 1`. Never updates an existing
  /// seeded row — only inserts ones with new [seedKey] values.
  static Future<void> reconcileInto(AppDatabase db) async {
    final deviceVersion =
        await db.metadataDao.getInt(seedVersionKey) ?? 0;
    if (deviceVersion >= currentSeedVersion) {
      debugPrint(
          'DbSeeder: device at seed v$deviceVersion, no reconciliation needed');
      return;
    }

    debugPrint(
        'DbSeeder: reconciling foods v$deviceVersion → v$currentSeedVersion');

    final tempPath = await _assetToTempFile(_foodsAsset);
    try {
      final seedDb = raw.sqlite3.open(tempPath);
      try {
        await reconcileFoodsFromRawDb(
          db,
          seedDb,
          targetSeedVersion: currentSeedVersion,
        );
      } finally {
        seedDb.dispose();
      }
    } finally {
      await File(tempPath).delete();
    }
  }

  /// Core reconciliation logic, separated from asset I/O for unit testing.
  ///
  /// Consumers should prefer [reconcileInto]. This entry point accepts an
  /// already-opened raw sqlite3 database (whose `foods` table matches the
  /// asset DB schema) plus an explicit [targetSeedVersion] so tests can
  /// simulate progressive updates without rebuilding the app.
  ///
  /// Behavior:
  ///   * Short-circuits if device's stored seed_version is already at or
  ///     above [targetSeedVersion]. Does NOT write the metadata row in that
  ///     case — version monotonicity is preserved regardless.
  ///   * Reads every non-null seed_key from the live foods table once, then
  ///     streams asset rows, inserting only those whose seed_key is absent.
  ///   * Wraps all writes (inserts + metadata stamp) in a single transaction
  ///     so a crash mid-reconcile never leaves seed_version ahead of the
  ///     actual row set.
  ///   * Leaves rows with `is_custom = 1` untouched by construction — they
  ///     have `seed_key = NULL` and therefore cannot collide with an asset
  ///     row's seed_key.
  @visibleForTesting
  static Future<ReconcileReport> reconcileFoodsFromRawDb(
    AppDatabase db,
    raw.Database seedDb, {
    required int targetSeedVersion,
  }) async {
    final deviceVersion =
        await db.metadataDao.getInt(seedVersionKey) ?? 0;
    if (deviceVersion >= targetSeedVersion) {
      return const ReconcileReport(inserted: 0, skipped: 0, skippedByShortCircuit: true);
    }

    final assetRows = seedDb.select('SELECT * FROM foods');

    // Snapshot every seed_key currently on-device in one query. Faster than
    // per-row existence checks, and safe because the transaction below holds
    // the write lock for the rest of this call.
    final existingSeeded = await (db.select(db.foods)
          ..where((f) => f.seedKey.isNotNull()))
        .get();
    final existingKeys =
        existingSeeded.map((f) => f.seedKey!).toSet();

    var inserted = 0;
    var skipped = 0;

    await db.transaction(() async {
      await db.batch((batch) {
        for (final row in assetRows) {
          final companion = _companionFromRow(row);
          final key = companion.seedKey.value;
          if (key == null || existingKeys.contains(key)) {
            skipped++;
            continue;
          }
          batch.insert(db.foods, companion);
          existingKeys.add(key); // Guard against duplicate keys in the asset.
          inserted++;
        }
      });

      await db.metadataDao.setInt(seedVersionKey, targetSeedVersion);
    });

    debugPrint(
        'DbSeeder: reconciliation complete — inserted=$inserted skipped=$skipped');

    return ReconcileReport(
      inserted: inserted,
      skipped: skipped,
      skippedByShortCircuit: false,
    );
  }

  /// Copies an asset to a temporary file so sqlite3 can open it, then returns
  /// the temp path. Caller must delete the file when done.
  static Future<String> _assetToTempFile(String assetPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final tempPath = p.join(dir.path, 'temp_${p.basename(assetPath)}');
    final data = await rootBundle.load(assetPath);
    await File(tempPath).writeAsBytes(
      data.buffer.asUint8List(),
      flush: true,
    );
    return tempPath;
  }

  static Future<void> _seedFoods(AppDatabase db) async {
    final tempPath = await _assetToTempFile(_foodsAsset);
    try {
      final seedDb = raw.sqlite3.open(tempPath);
      final result = seedDb.select('SELECT * FROM foods');
      debugPrint('DbSeeder: loading ${result.length} foods from asset');

      await db.batch((batch) {
        for (final row in result) {
          batch.insert(db.foods, _companionFromRow(row));
        }
      });

      seedDb.dispose();
    } finally {
      await File(tempPath).delete();
    }
  }

  static Future<void> _seedExercises(AppDatabase db) async {
    final tempPath = await _assetToTempFile(_exercisesAsset);
    try {
      final seedDb = raw.sqlite3.open(tempPath);
      final result = seedDb.select('SELECT * FROM exercises');
      debugPrint('DbSeeder: loading ${result.length} exercises from asset');

      await db.batch((batch) {
        for (final row in result) {
          batch.insert(
            db.exercises,
            ExercisesCompanion.insert(
              name: row['name'] as String,
              category: row['category'] as String,
              metValue: (row['met_value'] as num).toDouble(),
              description: Value(row['description'] as String?),
            ),
          );
        }
      });

      seedDb.dispose();
    } finally {
      await File(tempPath).delete();
    }
  }

  /// Builds a [FoodsCompanion] from one raw asset-DB row.
  ///
  /// Shared between [_seedFoods] (fresh install) and reconciliation so both
  /// paths handle nullable columns, defaults, and the seed_key fallback
  /// identically. Asset DBs predating the `seed_key` column still work via
  /// [_tryReadString].
  static FoodsCompanion _companionFromRow(raw.Row row) {
    final name = row['name'] as String;
    final brand = row['brand'] as String?;
    final assetSeedKey = _tryReadString(row, 'seed_key');
    final seedKey = assetSeedKey ?? makeSeedKey(name, brand);

    return FoodsCompanion.insert(
      name: name,
      brand: Value(brand),
      category: row['category'] as String,
      caloriesPer100g: (row['calories_per_100g'] as num).toDouble(),
      proteinPer100g:
          Value((row['protein_per_100g'] as num?)?.toDouble() ?? 0),
      carbsPer100g:
          Value((row['carbs_per_100g'] as num?)?.toDouble() ?? 0),
      fatPer100g:
          Value((row['fat_per_100g'] as num?)?.toDouble() ?? 0),
      fiberPer100g:
          Value((row['fiber_per_100g'] as num?)?.toDouble()),
      sugarPer100g:
          Value((row['sugar_per_100g'] as num?)?.toDouble()),
      sodiumPer100mg:
          Value((row['sodium_per_100mg'] as num?)?.toDouble()),
      defaultServingG:
          Value((row['default_serving_g'] as num?)?.toDouble() ?? 100),
      servingDescription: Value(row['serving_description'] as String?),
      isGlutenFree: Value(row['is_gluten_free'] as int? ?? 0),
      glutenStatus: Value(row['gluten_status'] as String? ?? 'unknown'),
      isCustom: Value(row['is_custom'] as int? ?? 0),
      seedKey: Value(seedKey),
    );
  }

  /// Returns the column value as a String, or null if the column doesn't exist
  /// in the row (e.g. older asset DBs that pre-date the column).
  static String? _tryReadString(raw.Row row, String column) {
    try {
      final v = row[column];
      return v as String?;
    } catch (_) {
      return null;
    }
  }
}

/// Summary of a single reconciliation pass. Returned by the testable entry
/// point [DbSeeder.reconcileFoodsFromRawDb] so tests can assert exact counts
/// and short-circuit behavior without scraping logs.
@immutable
class ReconcileReport {
  final int inserted;
  final int skipped;

  /// True if the caller was already at or above the target seed version and
  /// no work (including the metadata write) was performed.
  final bool skippedByShortCircuit;

  const ReconcileReport({
    required this.inserted,
    required this.skipped,
    required this.skippedByShortCircuit,
  });

  @override
  String toString() =>
      'ReconcileReport(inserted: $inserted, skipped: $skipped, '
      'shortCircuit: $skippedByShortCircuit)';
}
