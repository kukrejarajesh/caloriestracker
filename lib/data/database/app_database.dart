import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/seed_key.dart';
import '../tables/foods_table.dart';
import '../tables/food_logs_table.dart';
import '../tables/exercises_table.dart';
import '../tables/exercise_logs_table.dart';
import '../tables/water_logs_table.dart';
import '../tables/weight_logs_table.dart';
import '../tables/user_profile_table.dart';
import '../tables/metadata_table.dart';
import '../daos/foods_dao.dart';
import '../daos/food_logs_dao.dart';
import '../daos/exercise_logs_dao.dart';
import '../daos/water_logs_dao.dart';
import '../daos/weight_logs_dao.dart';
import '../daos/user_profile_dao.dart';
import '../daos/metadata_dao.dart';
import '../seed/db_seeder.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Foods,
    FoodLogs,
    Exercises,
    ExerciseLogs,
    WaterLogs,
    WeightLogs,
    UserProfile,
    Metadata,
  ],
  daos: [
    FoodsDao,
    FoodLogsDao,
    ExerciseLogsDao,
    WaterLogsDao,
    WeightLogsDao,
    UserProfileDao,
    MetadataDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : _skipSeeding = false,
        super(_openConnection());

  /// Constructor for tests — accepts any [QueryExecutor] (e.g. an in-memory
  /// NativeDatabase). Example usage:
  ///   AppDatabase.forTesting(NativeDatabase.memory(), skipSeeding: true)
  ///
  /// When [skipSeeding] is true, asset-based seed I/O is suppressed in BOTH
  /// lifecycle hooks that touch it:
  ///   * `onCreate`  will only run `createAll`; no [DbSeeder.seedInto] call,
  ///                 no `seed_version` metadata write.
  ///   * `beforeOpen` will skip [DbSeeder.reconcileInto], so tests can exercise
  ///                  DAO behavior on empty or hand-populated tables without
  ///                  needing path_provider / rootBundle / the Flutter binding.
  ///
  /// Tests that legitimately need seed data must load a fixture explicitly
  /// rather than re-enabling production seeding.
  AppDatabase.forTesting(super.e, {bool skipSeeding = false})
      : _skipSeeding = skipSeeding;

  /// Suppresses asset-based seeding and reconciliation in `onCreate` and
  /// `beforeOpen` respectively. Only set by the [AppDatabase.forTesting]
  /// constructor; production callers always get the full flow.
  final bool _skipSeeding;

  /// Schema version history:
  ///   v1 — initial schema (foods, food_logs, exercises, exercise_logs,
  ///        water_logs, weight_logs, user_profile).
  ///   v2 — adds `foods.seed_key` + `metadata` table. Enables additive
  ///        reconciliation of new seeded foods across releases without
  ///        overwriting user data or custom entries. Reconciliation itself
  ///        runs on every launch via `beforeOpen` → [DbSeeder.reconcileInto].
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          if (_skipSeeding) {
            // Test-only path: leave tables empty so DAO tests can control
            // their own fixtures without depending on the Flutter binding
            // that `DbSeeder.seedInto` requires.
            return;
          }
          // Seed asset data into the freshly-created tables.
          await DbSeeder.seedInto(this);
          // Record which seed version this fresh install corresponds to so
          // future upgrades know whether to reconcile.
          await metadataDao.setInt(
            DbSeeder.seedVersionKey,
            DbSeeder.currentSeedVersion,
          );
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Handle each version gate individually — safe for users who skip
          // releases (e.g. v1 → v5 runs every `if (from < N)` block in order).
          if (from < 2) {
            await _upgradeToV2(m);
          }
          // Future: if (from < 3) { ... }
        },
        beforeOpen: (OpeningDetails details) async {
          // Fresh installs already wrote `seed_version = currentSeedVersion`
          // from `onCreate`, so reconciliation would be a no-op — skip the
          // DAO round-trip.
          if (details.wasCreated) return;
          // Opt-out for tests (see [_skipSeeding]). `DbSeeder.reconcileInto`
          // reads an asset via path_provider + rootBundle and would crash
          // under a plain `flutter test` binding.
          if (_skipSeeding) return;
          // Additively insert any foods whose `seed_key` the device hasn't
          // seen yet. Idempotent — short-circuits when the device is already
          // at [DbSeeder.currentSeedVersion].
          await DbSeeder.reconcileInto(this);
        },
      );

  /// v1 → v2 migration.
  ///
  /// Additive only — never touches user-entered data (custom foods, food_logs,
  /// exercise_logs, water_logs, weight_logs, user_profile).
  ///
  /// 1. Add `seed_key` column to `foods` (nullable).
  /// 2. Create `metadata` table.
  /// 3. Backfill `seed_key` for every existing seeded food (is_custom = 0) by
  ///    computing the key from (name, brand) using [makeSeedKey]. Custom foods
  ///    keep seed_key = NULL.
  /// 4. Record `seed_version = 1` so the future reconciliation flow (Session 2)
  ///    knows this device is at the v1 seed set and needs updates shipped in
  ///    subsequent releases.
  Future<void> _upgradeToV2(Migrator m) async {
    debugPrint('AppDatabase: migrating v1 → v2');

    await m.addColumn(foods, foods.seedKey);
    await m.createTable(metadata);

    // Backfill seed_key for existing seeded rows. Custom rows stay NULL.
    final seeded = await (select(foods)..where((f) => f.isCustom.equals(0)))
        .get();
    debugPrint('AppDatabase: backfilling seed_key on ${seeded.length} seeded foods');

    // Backfill one row at a time via update() — batch.update is generic
    // and trickier to invoke inside a loop; the per-row cost is trivial
    // (runs once per install, on a small number of rows).
    for (final food in seeded) {
      await (update(foods)..where((f) => f.id.equals(food.id))).write(
        FoodsCompanion(seedKey: Value(makeSeedKey(food.name, food.brand))),
      );
    }

    // Mark this device as holding the v1 seed data. Session 2's reconciliation
    // will compare this to [DbSeeder.currentSeedVersion] on each launch and
    // insert newly-shipped foods additively.
    await metadataDao.setInt(DbSeeder.seedVersionKey, 1);

    debugPrint('AppDatabase: v2 migration complete');
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'calorie_tracker');
  }
}

/// Single shared [AppDatabase] instance for the entire app.
/// Override in tests via [ProviderScope] overrides.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
