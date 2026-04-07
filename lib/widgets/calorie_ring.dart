import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CalorieRing extends StatelessWidget {
  final double consumed;
  final double target;
  final double burned;

  const CalorieRing({
    super.key,
    required this.consumed,
    required this.target,
    required this.burned,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (target - consumed + burned).clamp(0, target);
    final over = (consumed - burned - target).clamp(0, double.infinity);
    final progress = (consumed - burned).clamp(0, target).toDouble();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringBg = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final sections = over > 0
        ? [
            PieChartSectionData(
              value: target,
              color: Colors.red.shade400,
              radius: 14,
              showTitle: false,
            ),
          ]
        : [
            PieChartSectionData(
              value: progress > 0 ? progress : 0.001,
              color: AppColors.primary,
              radius: 14,
              showTitle: false,
            ),
            PieChartSectionData(
              value: remaining > 0 ? remaining.toDouble() : 0.001,
              color: ringBg,
              radius: 14,
              showTitle: false,
            ),
          ];

    final net = (consumed - burned).round();
    final remainingInt = (target - net).round();
    final label = over > 0 ? 'Over goal' : 'Remaining';
    final valueText =
        over > 0 ? '+${over.round()} kcal' : '$remainingInt kcal';

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 72,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${consumed.round()}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: over > 0 ? Colors.red.shade400 : null,
                    ),
              ),
              Text(
                'of ${target.round()} kcal',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (over > 0 ? Colors.red : AppColors.primary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$label\n$valueText',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 11,
                        color: over > 0 ? Colors.red.shade400 : AppColors.primary,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
