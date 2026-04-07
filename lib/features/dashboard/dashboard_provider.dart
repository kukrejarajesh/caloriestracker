import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';

part 'dashboard_provider.g.dart';

// ── Today's date string ───────────────────────────────────────────────────────

@riverpod
String today(Ref ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

// ── Aggregated dashboard state ────────────────────────────────────────────────

class DashboardData {
  final List<FoodLog> foodLogs;
  final List<ExerciseLog> exerciseLogs;
  final UserProfileData? profile;

  const DashboardData({
    required this.foodLogs,
    required this.exerciseLogs,
    required this.profile,
  });

  double get calorieTarget => profile?.calorieTarget ?? 2000;
  double get proteinTarget => profile?.proteinTargetG ?? 50;
  double get carbsTarget => profile?.carbsTargetG ?? 250;
  double get fatTarget => profile?.fatTargetG ?? 65;
  int get waterTarget => profile?.waterTargetMl ?? 2000;

  double get totalCaloriesConsumed =>
      foodLogs.fold(0, (sum, l) => sum + l.calories);
  double get totalProtein =>
      foodLogs.fold(0, (sum, l) => sum + l.protein);
  double get totalCarbs =>
      foodLogs.fold(0, (sum, l) => sum + l.carbs);
  double get totalFat => foodLogs.fold(0, (sum, l) => sum + l.fat);

  double get totalCaloriesBurned =>
      exerciseLogs.fold(0, (sum, l) => sum + l.caloriesBurned);

  double get netCalories => totalCaloriesConsumed - totalCaloriesBurned;

  double get caloriesRemaining => calorieTarget - netCalories;

  List<FoodLog> logsForMeal(String mealType) =>
      foodLogs.where((l) => l.mealType == mealType).toList();
}

@riverpod
Stream<DashboardData> dashboard(Ref ref) async* {
  final db = ref.watch(appDatabaseProvider);
  final date = ref.watch(todayProvider);

  // Combine food logs + exercise logs + profile into one stream
  await for (final foodLogs
      in db.foodLogsDao.watchLogsForDate(date)) {
    final exerciseLogs =
        await db.exerciseLogsDao.getLogsForDate(date);
    final profile = await db.userProfileDao.getProfile();

    yield DashboardData(
      foodLogs: foodLogs,
      exerciseLogs: exerciseLogs,
      profile: profile,
    );
  }
}

// ── Water logs stream ─────────────────────────────────────────────────────────

@riverpod
Stream<int> todayWaterMl(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final date = ref.watch(todayProvider);

  return db.waterLogsDao
      .watchLogsForDate(date)
      .map((logs) => logs.fold(0, (sum, l) => sum + l.amountMl));
}
