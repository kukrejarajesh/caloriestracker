import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/water_logs_table.dart';

part 'water_logs_dao.g.dart';

@DriftAccessor(tables: [WaterLogs])
class WaterLogsDao extends DatabaseAccessor<AppDatabase>
    with _$WaterLogsDaoMixin {
  WaterLogsDao(super.db);

  Stream<List<WaterLog>> watchLogsForDate(String date) =>
      (select(waterLogs)..where((l) => l.date.equals(date))).watch();

  Future<List<WaterLog>> getLogsForDate(String date) =>
      (select(waterLogs)..where((l) => l.date.equals(date))).get();

  Future<int> insertLog(WaterLogsCompanion entry) =>
      into(waterLogs).insert(entry);

  Future<int> deleteLog(int id) =>
      (delete(waterLogs)..where((l) => l.id.equals(id))).go();
}
