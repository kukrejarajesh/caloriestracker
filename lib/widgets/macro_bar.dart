import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class MacroBar extends StatelessWidget {
  final double protein;
  final double proteinTarget;
  final double carbs;
  final double carbsTarget;
  final double fat;
  final double fatTarget;

  const MacroBar({
    super.key,
    required this.protein,
    required this.proteinTarget,
    required this.carbs,
    required this.carbsTarget,
    required this.fat,
    required this.fatTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MacroItem(
          label: 'Protein',
          value: protein,
          target: proteinTarget,
          color: AppColors.protein,
        ),
        const SizedBox(width: 12),
        _MacroItem(
          label: 'Carbs',
          value: carbs,
          target: carbsTarget,
          color: AppColors.carbs,
        ),
        const SizedBox(width: 12),
        _MacroItem(
          label: 'Fat',
          value: fat,
          target: fatTarget,
          color: AppColors.fat,
        ),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: color, fontSize: 12),
              ),
              Text(
                '${value.round()}g',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'of ${target.round()}g',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
