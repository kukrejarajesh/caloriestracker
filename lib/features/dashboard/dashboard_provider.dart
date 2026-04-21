import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';

part 'dashboard_provider.g.dart';

// ── Today's date string (fixed — always today) ────────────────────────────────

@riverpod
String today(Ref ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

// ── Dashboard date (navigable — defaults to today) ────────────────────────────

@riverpod
class DashboardDateNotifier extends _$DashboardDateNotifier {
  @override
  String build() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void goBack() {
    final d = DateTime.parse(state);
    final prev = d.subtract(const Duration(days: 1));
    state =
        '${prev.year}-${prev.month.toString().padLeft(2, '0')}-${prev.day.toString().padLeft(2, '0')}';
  }

  void goForward() {
    final d = DateTime.parse(state);
    final next = d.add(const Duration(days: 1));
    // Never navigate past today.
    if (next.isAfter(DateTime.now())) return;
    state =
        '${next.year}-${next.month.toString().padLeft(2, '0')}-${next.day.toString().padLeft(2, '0')}';
  }

  bool get isToday {
    final d = DateTime.parse(state);
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
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
  final date = ref.watch(dashboardDateNotifierProvider);

  // Profile rarely changes — fetch once per date-change.
  final profile = await db.userProfileDao.getProfile();

  // Latest values from each stream — updated independently.
  List<FoodLog> latestFood = const [];
  List<ExerciseLog> latestExercise = const [];

  // Single broadcast sink: either sub pushes here whenever its table changes.
  final controller = StreamController<DashboardData>();

  void push() {
    if (!controller.isClosed) {
      controller.add(DashboardData(
        foodLogs: latestFood,
        exerciseLogs: latestExercise,
        profile: profile,
      ));
    }
  }

  // Watch food logs — Drift emits immediately with current rows, then on change.
  final foodSub = db.foodLogsDao.watchLogsForDate(date).listen(
    (logs) { latestFood = logs; push(); },
    onError: controller.addError,
  );

  // Watch exercise logs — same reactive guarantee; fixes burned-calorie lag
  // and ensures deleted exercises disappear immediately (ENH-02 / ENH-04).
  final exerciseSub = db.exerciseLogsDao.watchLogsForDate(date).listen(
    (logs) { latestExercise = logs; push(); },
    onError: controller.addError,
  );

  try {
    yield* controller.stream;
  } finally {
    await foodSub.cancel();
    await exerciseSub.cancel();
    await controller.close();
  }
}

// ── Water logs stream ─────────────────────────────────────────────────────────

@riverpod
Stream<int> todayWaterMl(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final date = ref.watch(dashboardDateNotifierProvider);

  return db.waterLogsDao
      .watchLogsForDate(date)
      .map((logs) => logs.fold(0, (sum, l) => sum + l.amountMl));
}
