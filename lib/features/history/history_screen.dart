import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/calorie_ring.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/macro_bar.dart';
import '../../widgets/meal_section.dart';
import '../../widgets/water_tracker.dart';
import 'history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(historyDateProvider);
    final historyAsync = ref.watch(historyDataProvider);
    final waterAsync = ref.watch(historyWaterMlProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          TextButton.icon(
            onPressed: () => _pickDate(context, ref, selectedDate),
            icon: const Icon(Icons.calendar_today_outlined,
                color: Colors.white, size: 18),
            label: Text(
              _formatDate(selectedDate),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final waterMl = waterAsync.valueOrNull ?? 0;
          return ListView(
            children: [
              // ── Date nav ─────────────────────────────────────────────
              _DateNavBar(
                selectedDate: selectedDate,
                onPrev: () => _changeDate(ref, selectedDate, -1),
                onNext: () => _changeDate(ref, selectedDate, 1),
              ),

              // ── Calorie ring ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CalorieRing(
                    consumed: data.totalCaloriesConsumed,
                    target: data.calorieTarget,
                    burned: data.totalCaloriesBurned,
                  ),
                ),
              ),

              // ── Macro bar ────────────────────────────────────────────
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
              const SizedBox(height: 12),

              // ── Meal sections (read-only) ─────────────────────────────
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
                ),

              // ── Exercise ─────────────────────────────────────────────
              ExerciseCard(logs: data.exerciseLogs),

              // ── Water ────────────────────────────────────────────────
              WaterTracker(
                consumedMl: waterMl,
                targetMl: data.waterTarget,
                onAdd: (_) {}, // read-only in history
              ),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDate(
      BuildContext context, WidgetRef ref, String current) async {
    final initial = DateTime.tryParse(current) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final dateStr =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      ref.read(historyDateProvider.notifier).set(dateStr);
    }
  }

  void _changeDate(WidgetRef ref, String current, int days) {
    final d = DateTime.tryParse(current);
    if (d == null) return;
    final newD = d.add(Duration(days: days));
    if (newD.isAfter(DateTime.now())) return;
    final dateStr =
        '${newD.year}-${newD.month.toString().padLeft(2, '0')}-${newD.day.toString().padLeft(2, '0')}';
    ref.read(historyDateProvider.notifier).set(dateStr);
  }

  String _formatDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _DateNavBar extends StatelessWidget {
  final String selectedDate;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _DateNavBar({
    required this.selectedDate,
    required this.onPrev,
    required this.onNext,
  });

  String _formatNavDate(String dateStr) {
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

  @override
  Widget build(BuildContext context) {
    final d = DateTime.tryParse(selectedDate);
    final isToday = d != null &&
        d.year == DateTime.now().year &&
        d.month == DateTime.now().month &&
        d.day == DateTime.now().day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrev,
            color: AppColors.primary,
          ),
          Text(
            _formatNavDate(selectedDate),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: isToday ? null : onNext,
            color: isToday ? Colors.grey : AppColors.primary,
          ),
        ],
      ),
    );
  }
}
