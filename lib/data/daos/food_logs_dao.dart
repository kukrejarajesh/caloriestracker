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

  /// All distinct dates that have at least one food log, newest first.
  /// Used by the Statistics screen for streak calculation.
  Future<List<String>> getAllLoggedDates() async {
    final query = customSelect(
      'SELECT DISTINCT date FROM food_logs ORDER BY date DESC',
      readsFrom: {foodLogs},
    );
    final rows = await query.get();
    return rows.map((r) => r.read<String>('date')).toList();
  }

  /// All food logs whose date is in [dates]. Used by the Statistics screen
  /// to compute per-day calorie and macro totals for the selected period.
  Future<List<FoodLog>> getLogsForDates(List<String> dates) {
    if (dates.isEmpty) return Future.value([]);
    return (select(foodLogs)..where((l) => l.date.isIn(dates))).get();
  }
}
