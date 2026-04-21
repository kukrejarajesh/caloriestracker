import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/database/app_database.dart';

class ExerciseCard extends StatelessWidget {
  final List<ExerciseLog> logs;
  final VoidCallback? onAddExercise;
  final void Function(ExerciseLog log)? onDeleteLog;

  const ExerciseCard({
    super.key,
    required this.logs,
    this.onAddExercise,
    this.onDeleteLog,
  });

  double get _totalBurned =>
      logs.fold(0, (sum, l) => sum + l.caloriesBurned);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        leading: const Icon(Icons.fitness_center_outlined,
            color: AppColors.primary),
        title: Text('Exercise',
            style: Theme.of(context).textTheme.titleMedium),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _totalBurned == 0
                  ? '0 kcal'
                  : '−${_totalBurned.round()} kcal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          if (logs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Text(
                'No exercise logged yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            ...logs.map((log) => _ExerciseLogTile(
                  log: log,
                  onDelete: onDeleteLog != null
                      ? () => onDeleteLog!(log)
                      : null,
                )),
          TextButton.icon(
            onPressed: onAddExercise,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Exercise'),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ExerciseLogTile extends StatelessWidget {
  final ExerciseLog log;
  final VoidCallback? onDelete;

  const _ExerciseLogTile({required this.log, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.directions_run, color: Colors.white, size: 16),
      ),
      title: Text(
        log.exerciseName.isNotEmpty ? log.exerciseName : 'Exercise #${log.exerciseId}',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '${log.durationMinutes} min',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            log.caloriesBurned == 0
                ? '0 kcal'
                : '−${log.caloriesBurned.round()} kcal',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: onDelete,
              color: Theme.of(context).colorScheme.error,
            ),
        ],
      ),
    );
  }
}
