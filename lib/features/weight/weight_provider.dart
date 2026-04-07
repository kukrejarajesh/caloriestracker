import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';

part 'weight_provider.g.dart';

@riverpod
Stream<List<WeightLog>> weightLogs(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.weightLogsDao.watchAllLogs();
}

@riverpod
class WeightNotifier extends _$WeightNotifier {
  @override
  bool build() => false;

  Future<void> logWeight(double kg) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await db.weightLogsDao.insertLog(
      WeightLogsCompanion(
        date: Value(date),
        weightKg: Value(kg),
        loggedAt: Value(now.toIso8601String()),
      ),
    );
  }

  Future<void> deleteLog(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.weightLogsDao.deleteLog(id);
  }
}
