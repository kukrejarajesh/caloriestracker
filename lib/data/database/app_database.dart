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
  ///   v3 — adds `food_logs.food_name` + `exercise_logs.exercise_name`.
  ///   v4 — adds `user_profile.target_weight_kg` + `user_profile.pace_kg_per_week`.
  ///   v5 — expands `food_logs.meal_type` CHECK constraint to include
  ///        'morning_snack' and 'evening_snack'. SQLite cannot ALTER a CHECK
  ///        constraint, so the table is recreated via [_upgradeToV5].
  ///   v6 — expands `user_profile.activity_level` CHECK constraint to include
  ///        'extra_active'. Recreated via [_upgradeToV6].
  @override
  int get schemaVersion => 6;

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
          // Each gate checks both floor (from < N) and ceiling (to >= N) so
          // that the drift_dev migration-test framework can call onUpgrade with
          // an intermediate `to` value (e.g. from=1, to=2) without accidentally
          // running migrations beyond the requested target.
          // In production, `to` is always `schemaVersion` (the latest), so all
          // applicable blocks run in order — same as the old `if (from < N)`
          // pattern.
          if (from < 2 && to >= 2) {
            await _upgradeToV2(m);
          }
          if (from < 3 && to >= 3) {
            await _upgradeToV3(m);
          }
          if (from < 4 && to >= 4) {
            await _upgradeToV4(m);
          }
          if (from < 5 && to >= 5) {
            await _upgradeToV5(m);
          }
          if (from < 6 && to >= 6) {
            await _upgradeToV6(m);
          }
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

  /// v2 → v3 migration.
  ///
  /// Additive only — adds `food_name` to `food_logs` and `exercise_name`
  /// to `exercise_logs` so the dashboard can display real names without a
  /// JOIN on every render. Existing rows keep the empty-string default.
  Future<void> _upgradeToV3(Migrator m) async {
    debugPrint('AppDatabase: migrating v2 → v3 (add foodName/exerciseName)');
    await m.addColumn(foodLogs, foodLogs.foodName);
    await m.addColumn(exerciseLogs, exerciseLogs.exerciseName);
    debugPrint('AppDatabase: v3 migration complete');
  }

  /// v3 → v4 migration.
  ///
  /// Additive only — adds `target_weight_kg` and `pace_kg_per_week` to
  /// `user_profile` to support personalised calorie-target calculation.
  /// Existing rows get NULL / 0.5 defaults and will continue to use the
  /// legacy TDEE ± fixed-offset formula until the user sets a target weight.
  Future<void> _upgradeToV4(Migrator m) async {
    debugPrint('AppDatabase: migrating v3 → v4 (add targetWeightKg/paceKgPerWeek)');
    await m.addColumn(userProfile, userProfile.targetWeightKg);
    await m.addColumn(userProfile, userProfile.paceKgPerWeek);
    debugPrint('AppDatabase: v4 migration complete');
  }

  /// v4 → v5 migration.
  ///
  /// Expands the `food_logs.meal_type` CHECK constraint to include
  /// 'morning_snack' and 'evening_snack'. SQLite does not support
  /// `ALTER TABLE ... MODIFY COLUMN`, so the classic rename-and-copy trick is
  /// used instead:
  ///   1. Create `food_logs_new` with the updated constraint.
  ///   2. Copy all existing rows (superset constraint — no row ever fails).
  ///   3. Drop `food_logs`, rename `food_logs_new` → `food_logs`.
  ///
  /// FK enforcement is suspended for the duration because `food_logs` carries
  /// a `REFERENCES foods(id)` clause that would otherwise prevent the DROP.
  Future<void> _upgradeToV5(Migrator m) async {
    debugPrint(
        'AppDatabase: migrating v4 → v5 (expand meal_type constraint)');
    await customStatement('PRAGMA foreign_keys = OFF');
    await customStatement('''
      CREATE TABLE food_logs_new (
        id            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        date          TEXT    NOT NULL,
        meal_type     TEXT    NOT NULL
                              CHECK(meal_type IN (
                                'breakfast','morning_snack','lunch',
                                'evening_snack','dinner','snacks'
                              )),
        food_id       INTEGER NOT NULL REFERENCES foods (id),
        food_name     TEXT    NOT NULL DEFAULT '',
        quantity_g    REAL    NOT NULL,
        calories      REAL    NOT NULL,
        protein       REAL    NOT NULL DEFAULT 0.0,
        carbs         REAL    NOT NULL DEFAULT 0.0,
        fat           REAL    NOT NULL DEFAULT 0.0,
        gluten_status TEXT    NOT NULL DEFAULT 'unknown',
        logged_at     TEXT    NOT NULL
      )
    ''');
    await customStatement(
        'INSERT INTO food_logs_new SELECT * FROM food_logs');
    await customStatement('DROP TABLE food_logs');
    await customStatement(
        'ALTER TABLE food_logs_new RENAME TO food_logs');
    await customStatement('PRAGMA foreign_keys = ON');
    debugPrint('AppDatabase: v5 migration complete');
  }

  /// v5 → v6 migration.
  ///
  /// Expands the `user_profile.activity_level` CHECK constraint to include
  /// 'extra_active'. SQLite does not support `ALTER TABLE … MODIFY COLUMN`,
  /// so the rename-and-copy trick is used:
  ///   1. Create `user_profile_new` with the updated constraint.
  ///   2. Copy all existing rows (superset constraint — no row ever fails).
  ///   3. Drop `user_profile`, rename `user_profile_new` → `user_profile`.
  ///
  /// No `PRAGMA foreign_keys` manipulation is needed because nothing in the
  /// schema references `user_profile`.
  Future<void> _upgradeToV6(Migrator m) async {
    debugPrint(
        'AppDatabase: migrating v5 → v6 (expand activity_level constraint)');
    await customStatement('''
      CREATE TABLE user_profile_new (
        id                  INTEGER NOT NULL DEFAULT 1,
        name                TEXT NULL,
        date_of_birth       TEXT NULL,
        gender              TEXT CHECK(gender IN ('male','female','other')),
        height_cm           REAL NULL,
        weight_kg           REAL NULL,
        activity_level      TEXT CHECK(activity_level IN ('sedentary','lightly_active','moderately_active','very_active','extra_active')),
        goal_type           TEXT CHECK(goal_type IN ('lose','maintain','gain')),
        calorie_target      REAL NULL,
        protein_target_g    REAL NULL,
        carbs_target_g      REAL NULL,
        fat_target_g        REAL NULL,
        target_weight_kg    REAL NULL,
        pace_kg_per_week    REAL NOT NULL DEFAULT 0.5,
        water_target_ml     INTEGER NOT NULL DEFAULT 2000,
        is_gluten_free      INTEGER NOT NULL DEFAULT 1,
        db_version          INTEGER NOT NULL DEFAULT 1,
        onboarding_complete INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (id)
      )
    ''');
    await customStatement(
        'INSERT INTO user_profile_new SELECT * FROM user_profile');
    await customStatement('DROP TABLE user_profile');
    await customStatement(
        'ALTER TABLE user_profile_new RENAME TO user_profile');
    debugPrint('AppDatabase: v6 migration complete');
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
