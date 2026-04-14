import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tables/foods_table.dart';
import '../tables/food_logs_table.dart';
import '../tables/exercises_table.dart';
import '../tables/exercise_logs_table.dart';
import '../tables/water_logs_table.dart';
import '../tables/weight_logs_table.dart';
import '../tables/user_profile_table.dart';
import '../daos/foods_dao.dart';
import '../daos/food_logs_dao.dart';
import '../daos/exercise_logs_dao.dart';
import '../daos/water_logs_dao.dart';
import '../daos/weight_logs_dao.dart';
import '../daos/user_profile_dao.dart';
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
  ],
  daos: [
    FoodsDao,
    FoodLogsDao,
    ExerciseLogsDao,
    WaterLogsDao,
    WeightLogsDao,
    UserProfileDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for tests — accepts any [QueryExecutor] (e.g. an in-memory
  /// NativeDatabase). Example usage:
  ///   AppDatabase.forTesting(NativeDatabase.memory())
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // After tables are created, seed foods and exercises from asset DBs.
          await DbSeeder.seedInto(this);
        },
      );

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
