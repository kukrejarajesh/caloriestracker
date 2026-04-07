import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';
import '../dashboard/dashboard_provider.dart';

part 'history_provider.g.dart';

@riverpod
class HistoryDate extends _$HistoryDate {
  @override
  String build() {
    // Default to today
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void set(String date) => state = date;
}

@riverpod
Stream<DashboardData> historyData(Ref ref) async* {
  final db = ref.watch(appDatabaseProvider);
  final date = ref.watch(historyDateProvider);

  await for (final foodLogs in db.foodLogsDao.watchLogsForDate(date)) {
    final exerciseLogs = await db.exerciseLogsDao.getLogsForDate(date);
    final profile = await db.userProfileDao.getProfile();

    yield DashboardData(
      foodLogs: foodLogs,
      exerciseLogs: exerciseLogs,
      profile: profile,
    );
  }
}

@riverpod
Stream<int> historyWaterMl(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final date = ref.watch(historyDateProvider);
  return db.waterLogsDao
      .watchLogsForDate(date)
      .map((logs) => logs.fold(0, (sum, l) => sum + l.amountMl));
}
