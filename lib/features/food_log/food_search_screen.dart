import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/gluten_utils.dart';
import '../../data/database/app_database.dart';
import '../../widgets/gluten_badge.dart';
import 'custom_food_screen.dart';
import 'food_log_provider.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  /// The meal type passed from the dashboard (e.g. 'breakfast').
  final String mealType;

  /// The date to log food against (yyyy-MM-dd). Defaults to today if null.
  final String? logDate;

  const FoodSearchScreen({super.key, required this.mealType, this.logDate});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryNotifierProvider.notifier).set('');
    });
  }

  /// Converts 'morning_snack' → 'Morning Snack'.
  static String _titleCase(String s) => s
      .split('_')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  static bool _isToday(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return true;
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  static String _formatLogDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryNotifierProvider.notifier).set(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final glutenFreeOnly = ref.watch(glutenFilterNotifierProvider);
    final searchAsync = ref.watch(foodSearchProvider);
    final mealType = widget.mealType;

    // Show the target date in the AppBar when logging for a past date so
    // the user has clear confirmation of which day they're logging to (ENH-05).
    final showDateBanner = widget.logDate != null && !_isToday(widget.logDate!);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add to ${_titleCase(mealType)}'),
            if (showDateBanner)
              Text(
                'Logging for ${_formatLogDate(widget.logDate!)}',
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import CSV',
            onPressed: () async {
              await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => const CustomFoodScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => const CustomFoodScreen(),
            ),
          );
          if (added == true) {
            ref.invalidate(foodSearchProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // ── Search bar + gluten filter ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search foods…',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(searchQueryNotifierProvider.notifier)
                                    .set('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 8),
                _GlutenFilterChip(glutenFreeOnly: glutenFreeOnly),
              ],
            ),
          ),

          // ── Gluten filter notice ───────────────────────────────────────
          if (glutenFreeOnly)
            Container(
              width: double.infinity,
              color: AppColors.glutenSafeLight.withValues(alpha: 0.1),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.glutenSafeLight, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Showing gluten-free foods only',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.glutenSafeLight,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),

          // ── Results ────────────────────────────────────────────────────
          Expanded(
            child: searchAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (foods) {
                if (foods.isEmpty) {
                  return _EmptyState(
                    query: ref.watch(searchQueryNotifierProvider),
                    glutenFreeOnly: glutenFreeOnly,
                  );
                }
                return ListView.separated(
                  itemCount: foods.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, i) => _FoodResultTile(
                    food: foods[i],
                    mealType: mealType,
                    logDate: widget.logDate,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gluten filter chip ────────────────────────────────────────────────────────

class _GlutenFilterChip extends ConsumerWidget {
  final bool glutenFreeOnly;
  const _GlutenFilterChip({required this.glutenFreeOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterChip(
      label: const Text('GF Only'),
      selected: glutenFreeOnly,
      selectedColor: AppColors.glutenSafeLight.withValues(alpha: 0.2),
      checkmarkColor: AppColors.glutenSafeLight,
      side: BorderSide(
        color: glutenFreeOnly
            ? AppColors.glutenSafeLight
            : Colors.grey.withValues(alpha: 0.4),
      ),
      labelStyle: TextStyle(
        color: glutenFreeOnly ? AppColors.glutenSafeLight : null,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) =>
          ref.read(glutenFilterNotifierProvider.notifier).toggle(),
    );
  }
}

// ── Food result tile ──────────────────────────────────────────────────────────

class _FoodResultTile extends StatelessWidget {
  final Food food;
  final String mealType;
  final String? logDate;

  const _FoodResultTile({
    required this.food,
    required this.mealType,
    this.logDate,
  });

  @override
  Widget build(BuildContext context) {
    final isRisky = GlutenUtils.isRiskyString(food.glutenStatus);
    final riskColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.glutenWarningDark
        : AppColors.glutenWarningLight;

    return ListTile(
      tileColor: isRisky ? riskColor.withValues(alpha: 0.06) : null,
      leading: CircleAvatar(
        backgroundColor:
            isRisky ? riskColor.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          food.name.isNotEmpty ? food.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: isRisky ? riskColor : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        food.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isRisky ? riskColor : null,
            ),
      ),
      subtitle: Text(
        '${food.caloriesPer100g.round()} kcal / 100g'
        '${food.brand != null ? ' · ${food.brand}' : ''}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: GlutenBadge(glutenStatus: food.glutenStatus, compact: true),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _FoodDetailRoute(
            food: food,
            mealType: mealType,
            logDate: logDate,
          ),
        ),
      ),
    );
  }
}

// ── Wrapper to pass food to detail screen via route ───────────────────────────

class _FoodDetailRoute extends StatelessWidget {
  final Food food;
  final String mealType;
  final String? logDate;

  const _FoodDetailRoute({
    required this.food,
    required this.mealType,
    this.logDate,
  });

  @override
  Widget build(BuildContext context) {
    return _FoodDetailScreenInternal(
      food: food,
      mealType: mealType,
      logDate: logDate,
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String query;
  final bool glutenFreeOnly;

  const _EmptyState({required this.query, required this.glutenFreeOnly});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 56,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? 'Start typing to search foods'
                  : 'No foods found for "$query"',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (glutenFreeOnly && query.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Try turning off the GF filter to see all foods.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => const CustomFoodScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Custom Food'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep this alias so food_detail_screen.dart can use it via import
typedef _FoodDetailScreenInternal = _FoodDetailInline;

// Inline food detail to avoid a separate file import cycle
class _FoodDetailInline extends ConsumerStatefulWidget {
  final Food food;
  final String mealType;

  /// Date to log food against (yyyy-MM-dd). Falls back to today if null.
  final String? logDate;

  const _FoodDetailInline({
    required this.food,
    required this.mealType,
    this.logDate,
  });

  @override
  ConsumerState<_FoodDetailInline> createState() => _FoodDetailInlineState();
}

/// Serving unit options with their conversion factor to grams.
enum _ServingUnit {
  g('g', 1.0),
  ml('ml', 1.0),   // 1 ml ≈ 1 g (water density — good enough for nutrition)
  oz('oz', 28.35),
  cup('cup', 240.0),
  piece('piece', 100.0); // fallback — user sees the actual gram total

  const _ServingUnit(this.label, this.toGrams);
  final String label;
  final double toGrams;
}

class _FoodDetailInlineState extends ConsumerState<_FoodDetailInline> {
  late TextEditingController _qtyController;
  late double _unitQuantity;   // what the user typed, in the selected unit
  _ServingUnit _unit = _ServingUnit.g;

  /// Local meal-type state — initialised from widget.mealType so the chip
  /// pre-selects the meal the user came from (ENH-06).  Using a local field
  /// avoids the autoDispose mealTypeNotifierProvider being disposed between
  /// FoodSearchScreen.initState and this widget's first build.
  late String _mealType;

  @override
  void initState() {
    super.initState();
    _unitQuantity = widget.food.defaultServingG;
    _qtyController =
        TextEditingController(text: _unitQuantity.toStringAsFixed(0));
    _mealType = widget.mealType;
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  /// Quantity in grams — what gets stored in the DB.
  double get _quantity => _unitQuantity * _unit.toGrams;

  double get _ratio => _quantity / 100.0;
  double get _calories => widget.food.caloriesPer100g * _ratio;
  double get _protein => widget.food.proteinPer100g * _ratio;
  double get _carbs => widget.food.carbsPer100g * _ratio;
  double get _fat => widget.food.fatPer100g * _ratio;

  Future<void> _log(String mealType, String date) async {
    final ok = await ref.read(foodLogNotifierProvider.notifier).logFood(
          food: widget.food,
          mealType: mealType,
          date: date,
          quantityG: _quantity,
        );
    if (ok && mounted) {
      Navigator.of(context).popUntil((r) => r.isFirst || r.settings.name == '/dashboard');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.food.name} added to $mealType'),
          backgroundColor: AppColors.glutenSafeLight,
        ),
      );
    }
  }

  Future<void> _confirmAndLog(String mealType, String date) async {
    final status = GlutenStatus.fromString(widget.food.glutenStatus);
    if (status == GlutenStatus.containsGluten) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Gluten Warning'),
          content: Text(
            '${widget.food.name} contains gluten. '
            'Are you sure you want to log this food?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Log Anyway',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await _log(mealType, date);
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final logState = ref.watch(foodLogNotifierProvider);
    final date = widget.logDate ?? () {
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }();
    final status = GlutenStatus.fromString(food.glutenStatus);
    final isRisky = GlutenUtils.isRisky(status);

    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        actions: [
          if (food.isCustom == 1)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Custom Food',
              onPressed: () async {
                final edited = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => CustomFoodScreen(existingFood: food),
                  ),
                );
                if (edited == true && context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
        ],
      ),
      // Sticky log button — always visible regardless of scroll position
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(logState.error!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: logState.isLogging
                      ? null
                      : () => _confirmAndLog(_mealType, date),
                  icon: logState.isLogging
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(isRisky
                          ? Icons.warning_amber_outlined
                          : Icons.add_circle_outline),
                  label: Text(isRisky ? 'Log with Warning' : 'Log Food'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRisky
                        ? AppColors.glutenWarningLight
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gluten badge — always shown ────────────────────────────
            SizedBox(
              width: double.infinity,
              child: _GlutenWarningBanner(status: status),
            ),
            const SizedBox(height: 20),

            // ── Food info ──────────────────────────────────────────────
            if (food.brand != null)
              Text(food.brand!,
                  style: Theme.of(context).textTheme.bodyMedium),
            Text(food.category,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.primary)),
            const SizedBox(height: 20),

            // ── Quantity input ─────────────────────────────────────────
            Text('Serving Size',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v);
                      if (d != null && d > 0) {
                        setState(() => _unitQuantity = d);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<_ServingUnit>(
                  value: _unit,
                  underline: const SizedBox.shrink(),
                  items: _ServingUnit.values
                      .map((u) => DropdownMenuItem(
                            value: u,
                            child: Text(u.label),
                          ))
                      .toList(),
                  onChanged: (u) {
                    if (u != null) setState(() => _unit = u);
                  },
                ),
                const SizedBox(width: 12),
                if (food.servingDescription != null)
                  Expanded(
                    child: Text(
                      food.servingDescription!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Nutrition preview ──────────────────────────────────────
            Text('Nutrition',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _NutritionTable(
              calories: _calories,
              protein: _protein,
              carbs: _carbs,
              fat: _fat,
              fiber: food.fiberPer100g != null
                  ? food.fiberPer100g! * _ratio
                  : null,
              sugar: food.sugarPer100g != null
                  ? food.sugarPer100g! * _ratio
                  : null,
              sodium: food.sodiumPer100mg != null
                  ? food.sodiumPer100mg! * _ratio
                  : null,
            ),
            const SizedBox(height: 20),

            // ── Meal type selector ─────────────────────────────────────
            Text('Meal', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _MealTypeSelector(
              selected: _mealType,
              onSelected: (v) => setState(() => _mealType = v),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gluten warning banner ─────────────────────────────────────────────────────

class _GlutenWarningBanner extends StatelessWidget {
  final GlutenStatus status;
  const _GlutenWarningBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = GlutenUtils.badgeColor(status, context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(GlutenUtils.badgeIcon(status), color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              GlutenUtils.label(status),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nutrition table ───────────────────────────────────────────────────────────

class _NutritionTable extends StatelessWidget {
  final double calories, protein, carbs, fat;
  final double? fiber, sugar, sodium;

  const _NutritionTable({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Calories', '${calories.round()} kcal', AppColors.primary),
      ('Protein', '${protein.toStringAsFixed(1)}g', AppColors.protein),
      ('Carbohydrates', '${carbs.toStringAsFixed(1)}g', AppColors.carbs),
      ('Fat', '${fat.toStringAsFixed(1)}g', AppColors.fat),
      if (fiber != null)
        ('Fiber', '${fiber!.toStringAsFixed(1)}g', AppColors.fiber),
      if (sugar != null) ('Sugar', '${sugar!.toStringAsFixed(1)}g', AppColors.carbs),
      if (sodium != null) ('Sodium', '${sodium!.toStringAsFixed(1)}mg', Colors.grey),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: rows.map((r) {
            final (label, value, color) = r;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Container(
                      width: 3,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(label,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Meal type selector ────────────────────────────────────────────────────────

class _MealTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _MealTypeSelector(
      {required this.selected, required this.onSelected});

  static const _meals = [
    ('breakfast',     'Breakfast'),
    ('morning_snack', 'Morning Snack'),
    ('lunch',         'Lunch'),
    ('evening_snack', 'Evening Snack'),
    ('dinner',        'Dinner'),
    ('snacks',        'Snacks'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _meals.map((m) {
        final (value, label) = m;
        final isSelected = selected == value;
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          onSelected: (_) => onSelected(value),
        );
      }).toList(),
    );
  }
}
