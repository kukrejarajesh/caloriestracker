import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/met_calculator.dart';
import '../../data/database/app_database.dart';
import 'exercise_log_provider.dart';

class ExerciseLogScreen extends ConsumerStatefulWidget {
  final Exercise exercise;
  const ExerciseLogScreen({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseLogScreen> createState() =>
      _ExerciseLogScreenState();
}

class _ExerciseLogScreenState extends ConsumerState<ExerciseLogScreen> {
  final _durationController = TextEditingController(text: '30');
  int _duration = 30;
  double _userWeight = 70.0;

  @override
  void initState() {
    super.initState();
    _loadWeight();
  }

  Future<void> _loadWeight() async {
    final db = ref.read(appDatabaseProvider);
    final profile = await db.userProfileDao.getProfile();
    if (profile?.weightKg != null && mounted) {
      setState(() => _userWeight = profile!.weightKg!);
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  double get _burned => MetCalculator.caloriesBurnedRounded(
        metValue: widget.exercise.metValue,
        weightKg: _userWeight,
        durationMinutes: _duration,
      );

  Future<void> _log() async {
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final ok = await ref
        .read(exerciseLogNotifierProvider.notifier)
        .logExercise(
          exercise: widget.exercise,
          durationMinutes: _duration,
          date: date,
        );

    if (ok && mounted) {
      Navigator.of(context).popUntil((r) => r.isFirst || r.settings.name == '/dashboard');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${widget.exercise.name} logged — ${_burned.round()} kcal burned'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logState = ref.watch(exerciseLogNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Exercise info ──────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.fitness_center,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.exercise.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium),
                          Text(widget.exercise.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium),
                          if (widget.exercise.description != null)
                            Text(widget.exercise.description!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Duration input ─────────────────────────────────────────
            Text('Duration',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(suffixText: 'min'),
                    onChanged: (v) {
                      final d = int.tryParse(v);
                      if (d != null && d > 0) {
                        setState(() => _duration = d);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Quick duration chips
                for (final mins in [15, 30, 45, 60])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text('${mins}m'),
                      onPressed: () {
                        setState(() {
                          _duration = mins;
                          _durationController.text = '$mins';
                        });
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Calories burned preview ────────────────────────────────
            Card(
              color: AppColors.primary.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      '${_burned.round()} kcal burned',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on your weight (${_userWeight.toStringAsFixed(1)} kg) · MET ${widget.exercise.metValue}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),

            // ── Log button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: logState.isLogging ? null : _log,
                icon: logState.isLogging
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: const Text('Log Exercise'),
              ),
            ),
            if (logState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(logState.error!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }
}
