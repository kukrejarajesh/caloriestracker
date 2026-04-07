import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../widgets/calorie_ring.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/macro_bar.dart';
import '../../widgets/meal_section.dart';
import '../../widgets/water_tracker.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(dashboardProvider);
    final waterAsync = ref.watch(todayWaterMlProvider);
    final date = ref.watch(todayProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatDate(date)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
            tooltip: 'Profile',
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
        onPressed: () => Navigator.of(context).pushNamed('/food-search'),
        icon: const Icon(Icons.add),
        label: const Text('Log Food'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  String _formatDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
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
        for (final meal in ['breakfast', 'lunch', 'dinner', 'snacks'])
          MealSection(
            mealType: meal,
            logs: data.logsForMeal(meal),
            onAddFood: () =>
                Navigator.of(context).pushNamed('/food-search'),
            onDeleteLog: (log) => _deleteFoodLog(ref, log),
          ),

        // ── Exercise card ──────────────────────────────────────────────────
        ExerciseCard(
          logs: data.exerciseLogs,
          onAddExercise: () =>
              Navigator.of(context).pushNamed('/exercise-search'),
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
