import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/food_logs_table.dart';

part 'food_logs_dao.g.dart';

@DriftAccessor(tables: [FoodLogs])
class FoodLogsDao extends DatabaseAccessor<AppDatabase>
    with _$FoodLogsDaoMixin {
  FoodLogsDao(super.db);

  /// Stream of all food logs for a given date (yyyy-MM-dd).
  Stream<List<FoodLog>> watchLogsForDate(String date) =>
      (select(foodLogs)..where((l) => l.date.equals(date))).watch();

  Future<List<FoodLog>> getLogsForDate(String date) =>
      (select(foodLogs)..where((l) => l.date.equals(date))).get();

  Future<int> insertLog(FoodLogsCompanion entry) =>
      into(foodLogs).insert(entry);

  Future<bool> updateLog(FoodLogsCompanion entry) =>
      update(foodLogs).replace(entry);

  Future<int> deleteLog(int id) =>
      (delete(foodLogs)..where((l) => l.id.equals(id))).go();
}
