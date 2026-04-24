import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/tdee_calculator.dart';
import '../../data/database/app_database.dart';
import '../../widgets/calorie_ring.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/macro_bar.dart';
import '../../widgets/meal_section.dart';
import '../../widgets/water_tracker.dart';
import '../profile/profile_screen.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(dashboardProvider);
    final waterAsync = ref.watch(todayWaterMlProvider);
    final date = ref.watch(dashboardDateNotifierProvider);
    final notifier = ref.read(dashboardDateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              tooltip: 'Previous day',
              onPressed: notifier.goBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            Text(_formatDate(date)),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: notifier.isToday
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.white,
              ),
              tooltip: notifier.isToday ? 'Already on today' : 'Next day',
              onPressed: notifier.isToday ? null : notifier.goForward,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Nutrition Summary',
            onPressed: () {
              final data = ref.read(dashboardProvider).valueOrNull;
              if (data != null) _showNutritionSummary(context, data);
            },
          ),
        ],
      ),
      body: dashAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error loading dashboard: $e')),
        data: (data) => _DashboardBody(
          data: data,
          waterMl: waterAsync.valueOrNull ?? 0,
          date: date,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(
          '/food-search',
          arguments: {'mealType': 'breakfast', 'date': date},
        ),
        icon: const Icon(Icons.add),
        label: const Text('Log Food'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showNutritionSummary(BuildContext context, DashboardData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _NutritionSummarySheet(data: data),
    );
  }

  String _formatDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }
}

class _DashboardBody extends ConsumerWidget {
  final DashboardData data;
  final int waterMl;
  final String date;

  const _DashboardBody({
    required this.data,
    required this.waterMl,
    required this.date,
  });

  Future<void> _addWater(WidgetRef ref, int ml) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().toIso8601String();
    await db.waterLogsDao.insertLog(
      WaterLogsCompanion(
        date: Value(date),
        amountMl: Value(ml),
        loggedAt: Value(now),
      ),
    );
  }

  Future<void> _deleteFoodLog(WidgetRef ref, FoodLog log) async {
    final db = ref.read(appDatabaseProvider);
    await db.foodLogsDao.deleteLog(log.id);
  }

  Future<void> _deleteExerciseLog(WidgetRef ref, ExerciseLog log) async {
    final db = ref.read(appDatabaseProvider);
    await db.exerciseLogsDao.deleteLog(log.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        // ── Calorie ring ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: CalorieRing(
              consumed: data.totalCaloriesConsumed,
              target: data.calorieTarget,
              burned: data.totalCaloriesBurned,
            ),
          ),
        ),

        // ── Goal summary banner ────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _GoalSummaryBanner(data: data),
        ),
        const SizedBox(height: 8),

        // ── Macro bar ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MacroBar(
            protein: data.totalProtein,
            proteinTarget: data.proteinTarget,
            carbs: data.totalCarbs,
            carbsTarget: data.carbsTarget,
            fat: data.totalFat,
            fatTarget: data.fatTarget,
          ),
        ),
        const SizedBox(height: 16),

        // ── Calorie summary row ────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _CalorieSummaryRow(data: data),
        ),
        const SizedBox(height: 8),

        // ── Meal sections ──────────────────────────────────────────────────
        for (final meal in [
          'breakfast',
          'morning_snack',
          'lunch',
          'evening_snack',
          'dinner',
          'snacks',
        ])
          MealSection(
            mealType: meal,
            logs: data.logsForMeal(meal),
            onAddFood: () => Navigator.of(context).pushNamed(
              '/food-search',
              arguments: {'mealType': meal, 'date': date},
            ),
            onDeleteLog: (log) => _deleteFoodLog(ref, log),
          ),

        // ── Exercise card ──────────────────────────────────────────────────
        ExerciseCard(
          logs: data.exerciseLogs,
          onAddExercise: () => Navigator.of(context).pushNamed(
            '/exercise-search',
            arguments: {'date': date},
          ),
          onDeleteLog: (log) => _deleteExerciseLog(ref, log),
        ),

        // ── Water tracker ──────────────────────────────────────────────────
        WaterTracker(
          consumedMl: waterMl,
          targetMl: data.waterTarget,
          onAdd: (ml) => _addWater(ref, ml),
        ),

        const SizedBox(height: 80), // FAB clearance
      ],
    );
  }
}

// ── Calorie summary row (consumed / burned / net) ─────────────────────────────

class _CalorieSummaryRow extends StatelessWidget {
  final DashboardData data;

  const _CalorieSummaryRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryItem(
          label: 'Consumed',
          value: data.totalCaloriesConsumed.round(),
          color: AppColors.primary,
        ),
        _divider(),
        _SummaryItem(
          label: 'Burned',
          value: data.totalCaloriesBurned.round(),
          color: AppColors.water,
        ),
        _divider(),
        _SummaryItem(
          label: 'Net',
          value: data.netCalories.round(),
          color: data.netCalories > data.calorieTarget
              ? AppColors.glutenWarningLight
              : AppColors.glutenSafeLight,
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: Colors.grey.withValues(alpha: 0.3),
      );
}

// ── Nutrition summary bottom sheet (ENH-03) ───────────────────────────────────

class _NutritionSummarySheet extends StatelessWidget {
  final DashboardData data;
  const _NutritionSummarySheet({required this.data});

  static const _allMeals = [
    ('breakfast',     'Breakfast'),
    ('morning_snack', 'Morning Snack'),
    ('lunch',         'Lunch'),
    ('evening_snack', 'Evening Snack'),
    ('dinner',        'Dinner'),
    ('snacks',        'Snacks'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildMacroRow(
        String label, double consumed, double target, Color color) {
      final pct = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: color.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${consumed.round()}/${target.round()}g',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text("Today's Nutrition",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '${data.totalCaloriesConsumed.round()} of '
                '${data.calorieTarget.round()} kcal consumed',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              // Calorie progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: data.calorieTarget > 0
                      ? (data.totalCaloriesConsumed / data.calorieTarget)
                          .clamp(0.0, 1.0)
                      : 0.0,
                  minHeight: 10,
                  backgroundColor:
                      AppColors.primary.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),

              // Macro breakdown
              Text('Macros',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: AppColors.primary)),
              const Divider(height: 12),
              buildMacroRow('Protein', data.totalProtein,
                  data.proteinTarget, AppColors.protein),
              buildMacroRow('Carbs', data.totalCarbs,
                  data.carbsTarget, AppColors.carbs),
              buildMacroRow('Fat', data.totalFat,
                  data.fatTarget, AppColors.fat),
              const SizedBox(height: 20),

              // Meal breakdown
              Text('Meal Breakdown',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: AppColors.primary)),
              const Divider(height: 12),
              ..._allMeals.map((m) {
                final (mealType, label) = m;
                final kcal = data
                    .logsForMeal(mealType)
                    .fold(0.0, (s, l) => s + l.calories);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Text(label,
                          style: theme.textTheme.bodyLarge),
                      const Spacer(),
                      Text(
                        '${kcal.round()} kcal',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Burned (exercise)',
                      style: theme.textTheme.bodyLarge),
                  const Spacer(),
                  Text(
                    '−${data.totalCaloriesBurned.round()} kcal',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text('Net',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    '${data.netCalories.round()} kcal',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: data.netCalories > data.calorieTarget
                            ? AppColors.glutenWarningLight
                            : AppColors.glutenSafeLight),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Goal summary banner ───────────────────────────────────────────────────────

class _GoalSummaryBanner extends StatelessWidget {
  final DashboardData data;
  const _GoalSummaryBanner({required this.data});

  @override
  Widget build(BuildContext context) {
    final profile = data.profile;
    final goalType = profile?.goalType ?? 'maintain';

    String label;
    if (goalType == 'maintain') {
      label = 'Goal: Maintain weight';
    } else {
      final current = profile?.weightKg;
      final target = profile?.targetWeightKg;
      final pace = profile?.paceKgPerWeek ?? 0.5;
      final kgLabel = (current != null && target != null)
          ? '${(current - target).abs().toStringAsFixed(1)} kg'
          : '';
      final weeks = (current != null && target != null)
          ? TdeeCalculator.weeksToGoal(
              currentWeightKg: current,
              targetWeightKg: target,
              paceKgPerWeek: pace,
            )
          : null;
      final action = goalType == 'lose' ? 'Lose' : 'Gain';
      label = (kgLabel.isNotEmpty && weeks != null)
          ? 'Goal: $action $kgLabel · ~$weeks weeks at current pace'
          : 'Goal: $action weight';
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.flag_outlined,
                size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
