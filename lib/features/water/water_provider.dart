import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';
import '../dashboard/dashboard_provider.dart';

part 'water_provider.g.dart';

@riverpod
Stream<List<WaterLog>> waterLogs(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final date = ref.watch(todayProvider);
  return db.waterLogsDao.watchLogsForDate(date);
}

@riverpod
class WaterNotifier extends _$WaterNotifier {
  @override
  bool build() => false; // loading state

  Future<void> addWater(int ml) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await db.waterLogsDao.insertLog(
      WaterLogsCompanion(
        date: Value(date),
        amountMl: Value(ml),
        loggedAt: Value(now.toIso8601String()),
      ),
    );
  }

  Future<void> deleteLog(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.waterLogsDao.deleteLog(id);
  }
}
