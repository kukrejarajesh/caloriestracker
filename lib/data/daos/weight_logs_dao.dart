import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/weight_logs_table.dart';

part 'weight_logs_dao.g.dart';

@DriftAccessor(tables: [WeightLogs])
class WeightLogsDao extends DatabaseAccessor<AppDatabase>
    with _$WeightLogsDaoMixin {
  WeightLogsDao(super.db);

  Stream<List<WeightLog>> watchAllLogs() =>
      (select(weightLogs)..orderBy([(l) => OrderingTerm.asc(l.date)])).watch();

  Future<List<WeightLog>> getAllLogs() =>
      (select(weightLogs)..orderBy([(l) => OrderingTerm.asc(l.date)])).get();

  Future<int> insertLog(WeightLogsCompanion entry) =>
      into(weightLogs).insert(entry);

  Future<int> deleteLog(int id) =>
      (delete(weightLogs)..where((l) => l.id.equals(id))).go();
}
