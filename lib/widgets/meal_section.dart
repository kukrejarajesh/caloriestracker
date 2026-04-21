import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/gluten_utils.dart';
import '../data/database/app_database.dart';
import 'gluten_badge.dart';

class MealSection extends StatelessWidget {
  final String mealType;
  final List<FoodLog> logs;
  final VoidCallback? onAddFood;
  final void Function(FoodLog log)? onDeleteLog;

  const MealSection({
    super.key,
    required this.mealType,
    required this.logs,
    this.onAddFood,
    this.onDeleteLog,
  });

  static const _mealIcons = {
    'breakfast':     Icons.wb_sunny_outlined,
    'morning_snack': Icons.coffee_outlined,
    'lunch':         Icons.lunch_dining_outlined,
    'evening_snack': Icons.local_cafe_outlined,
    'dinner':        Icons.dinner_dining_outlined,
    'snacks':        Icons.cookie_outlined,
  };

  /// Converts 'morning_snack' → 'Morning Snack', 'breakfast' → 'Breakfast'.
  String get _title => mealType
      .split('_')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  double get _totalCalories =>
      logs.fold(0, (sum, l) => sum + l.calories);

  @override
  Widget build(BuildContext context) {
    final hasGlutenRisk =
        logs.any((l) => GlutenUtils.isRiskyString(l.glutenStatus));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        leading: Icon(
          _mealIcons[mealType] ?? Icons.restaurant_outlined,
          color: hasGlutenRisk
              ? AppColors.glutenWarningLight
              : AppColors.primary,
        ),
        title: Row(
          children: [
            Text(_title,
                style: Theme.of(context).textTheme.titleMedium),
            if (hasGlutenRisk) ...[
              const SizedBox(width: 8),
              const GlutenBadge(
                  glutenStatus: 'contains_gluten', compact: true),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_totalCalories.round()} kcal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          if (logs.isEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'No foods logged yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            ...logs.map((log) => _FoodLogTile(
                  log: log,
                  onDelete: onDeleteLog != null
                      ? () => onDeleteLog!(log)
                      : null,
                )),
          // Add food button
          TextButton.icon(
            onPressed: onAddFood,
            icon: const Icon(Icons.add, size: 18),
            label: Text('Add to $_title'),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _FoodLogTile extends StatelessWidget {
  final FoodLog log;
  final VoidCallback? onDelete;

  const _FoodLogTile({required this.log, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isRisky = GlutenUtils.isRiskyString(log.glutenStatus);
    final riskColor = isRisky
        ? (Theme.of(context).brightness == Brightness.dark
            ? AppColors.glutenWarningDark
            : AppColors.glutenWarningLight)
        : null;

    return ListTile(
      dense: true,
      tileColor: isRisky
          ? (riskColor?.withValues(alpha: 0.08))
          : null,
      title: Row(
        children: [
          Expanded(
            child: Text(
              log.foodName.isNotEmpty ? log.foodName : 'Food #${log.foodId}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: riskColor,
                  ),
            ),
          ),
          GlutenBadge(glutenStatus: log.glutenStatus, compact: true),
        ],
      ),
      subtitle: Text(
        '${log.quantityG.round()}g · '
        'P ${log.protein.round()}g · '
        'C ${log.carbs.round()}g · '
        'F ${log.fat.round()}g',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${log.calories.round()} kcal',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: riskColor,
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
