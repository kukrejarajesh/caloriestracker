import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/tdee_calculator.dart';
import '../../data/database/app_database.dart';
import '../dashboard/dashboard_provider.dart';
import 'weight_provider.dart';

class WeightScreen extends ConsumerWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(weightLogsProvider);
    final profileAsync = ref.watch(dashboardProvider);
    final goalType = profileAsync.valueOrNull?.profile?.goalType ?? 'maintain';

    return Scaffold(
      appBar: AppBar(title: const Text('Weight Trend')),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (logs) => _WeightBody(logs: logs, goalType: goalType),
      ),
    );
  }
}

class _WeightBody extends ConsumerStatefulWidget {
  final List<WeightLog> logs;
  final String goalType;

  const _WeightBody({required this.logs, required this.goalType});

  @override
  ConsumerState<_WeightBody> createState() => _WeightBodyState();
}

class _WeightBodyState extends ConsumerState<_WeightBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _log() async {
    final kg = double.tryParse(_controller.text);
    if (kg == null || kg < 20 || kg > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid weight (20–500 kg)')),
      );
      return;
    }
    await ref.read(weightNotifierProvider.notifier).logWeight(kg);
    _controller.clear();

    // Recalculate calorie target with the new weight and update profile.
    if (!mounted) return;
    final db = ref.read(appDatabaseProvider);
    final profile = await db.userProfileDao.getProfile();
    if (profile != null && mounted) {
      final age = TdeeCalculator.ageFromDob(
          profile.dateOfBirth ?? '1990-01-01');
      final bmr = TdeeCalculator.bmr(
        weightKg: kg,
        heightCm: profile.heightCm ?? 170,
        ageYears: age,
        gender: profile.gender ?? 'male',
      );
      final tdeeVal = TdeeCalculator.tdee(
        bmr: bmr,
        activityLevel: profile.activityLevel ?? 'moderately_active',
      );
      final goalType = profile.goalType ?? 'maintain';
      final pace = profile.paceKgPerWeek;
      final newTarget =
          (profile.targetWeightKg != null && goalType != 'maintain')
              ? TdeeCalculator.personalizedCalorieTarget(
                  tdeeValue: tdeeVal,
                  goalType: goalType,
                  paceKgPerWeek: pace,
                  gender: profile.gender ?? 'male',
                )
              : TdeeCalculator.calorieTarget(tdeeVal, goalType);
      final macros = TdeeCalculator.macroTargets(newTarget, goalType);

      await db.userProfileDao.upsertProfile(
        UserProfileCompanion(
          id: const Value(1),
          weightKg: Value(kg),
          calorieTarget: Value(newTarget),
          proteinTargetG: Value(macros.proteinG),
          carbsTargetG: Value(macros.carbsG),
          fatTargetG: Value(macros.fatG),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Daily target updated to ${newTarget.round()} kcal based on your new weight'),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Goal reached check
      final targetWt = profile.targetWeightKg;
      final reached = targetWt != null &&
          ((goalType == 'lose' && kg <= targetWt) ||
              (goalType == 'gain' && kg >= targetWt));
      if (reached && mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("You've reached your goal!"),
            content:
                const Text('Would you like to switch to Maintain?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Not yet'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await db.userProfileDao.upsertProfile(
                    const UserProfileCompanion(
                      id: Value(1),
                      goalType: Value('maintain'),
                    ),
                  );
                },
                child: const Text('Switch to Maintain'),
              ),
            ],
          ),
        );
      }
    } else if (mounted) {
      // Fallback if no profile yet — just confirm the log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Weight logged: ${kg}kg'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recent = widget.logs.length > 30
        ? widget.logs.sublist(widget.logs.length - 30)
        : widget.logs;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Log today's weight ─────────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Weight",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Weight', suffixText: 'kg'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                        onPressed: _log, child: const Text('Log')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Chart ──────────────────────────────────────────────────────
        if (recent.length >= 2) ...[
          Text('Weight Log',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: _WeightChart(logs: recent, goalType: widget.goalType),
          ),
          const SizedBox(height: 20),
        ] else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Log at least 2 entries to see your trend.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],

        // ── History list ───────────────────────────────────────────────
        if (widget.logs.isNotEmpty) ...[
          Text('History',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...widget.logs.reversed.map(
            (log) => ListTile(
              dense: true,
              leading:
                  const Icon(Icons.monitor_weight_outlined,
                      color: AppColors.primary),
              title: Text('${log.weightKg} kg',
                  style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(log.date,
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: () => ref
                    .read(weightNotifierProvider.notifier)
                    .deleteLog(log.id),
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _WeightChart extends StatelessWidget {
  final List<WeightLog> logs;
  final String goalType;

  const _WeightChart({required this.logs, required this.goalType});

  @override
  Widget build(BuildContext context) {
    final spots = logs.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weightKg);
    }).toList();

    final weights = logs.map((l) => l.weightKg).toList();
    final minY = (weights.reduce((a, b) => a < b ? a : b) - 2)
        .clamp(0.0, double.infinity);
    final maxY = weights.reduce((a, b) => a > b ? a : b) + 2;

    // Green for all goals — a downward trend is positive for "lose",
    // upward for "gain", and stable for "maintain". Red would feel alarming
    // regardless of direction, so we always use the brand primary green.
    const lineColor = AppColors.primary;

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.grey.withValues(alpha: 0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (v, _) => Text(
                v.toStringAsFixed(0),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 10),
              ),
            ),
          ),
          bottomTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                radius: 3,
                color: lineColor,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
