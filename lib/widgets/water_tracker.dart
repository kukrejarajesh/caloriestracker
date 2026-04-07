import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class WaterTracker extends StatelessWidget {
  final int consumedMl;
  final int targetMl;
  final void Function(int ml) onAdd;

  const WaterTracker({
    super.key,
    required this.consumedMl,
    required this.targetMl,
    required this.onAdd,
  });

  static const _quickAmounts = [200, 350, 500];

  @override
  Widget build(BuildContext context) {
    final progress =
        targetMl > 0 ? (consumedMl / targetMl).clamp(0.0, 1.0) : 0.0;
    final remaining = (targetMl - consumedMl).clamp(0, targetMl);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop_outlined,
                    color: AppColors.water),
                const SizedBox(width: 8),
                Text('Water',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  '${_formatMl(consumedMl)} / ${_formatMl(targetMl)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.water,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor:
                    AppColors.water.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.water),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              remaining > 0
                  ? '${_formatMl(remaining)} more to reach your goal'
                  : 'Daily goal reached!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: remaining == 0 ? AppColors.glutenSafeLight : null,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: _quickAmounts
                  .map((ml) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text('+${_formatMl(ml)}'),
                          avatar: const Icon(Icons.add,
                              size: 14, color: AppColors.water),
                          onPressed: () => onAdd(ml),
                          side: const BorderSide(color: AppColors.water),
                          labelStyle: const TextStyle(
                              color: AppColors.water, fontSize: 12),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMl(int ml) =>
      ml >= 1000 ? '${(ml / 1000).toStringAsFixed(1)}L' : '${ml}ml';
}
