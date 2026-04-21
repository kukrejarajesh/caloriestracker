import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/gluten_utils.dart';
import '../../data/database/app_database.dart';
import '../../widgets/gluten_badge.dart';
import 'food_log_provider.dart';

/// Categories available for food items.
const _foodCategories = [
  'Grains/Cereals',
  'Dairy',
  'Meat/Poultry',
  'Fish/Seafood',
  'Vegetables',
  'Fruits',
  'Legumes/Pulses',
  'Nuts/Seeds',
  'Beverages',
  'Snacks',
  'Sweets/Desserts',
  'Oils/Fats',
  'Spices/Condiments',
];

/// Gluten status options matching DB CHECK constraint.
const _glutenStatusOptions = [
  'unknown',
  'gluten_free',
  'contains_gluten',
  'may_contain',
];

/// Screen for creating or editing a custom food entry.
///
/// Pass [existingFood] to edit an existing custom food.
class CustomFoodScreen extends ConsumerStatefulWidget {
  final Food? existingFood;

  const CustomFoodScreen({super.key, this.existingFood});

  @override
  ConsumerState<CustomFoodScreen> createState() => _CustomFoodScreenState();
}

class _CustomFoodScreenState extends ConsumerState<CustomFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _fiberController;
  late final TextEditingController _sugarController;
  late final TextEditingController _sodiumController;
  late final TextEditingController _servingGController;
  late final TextEditingController _servingDescController;

  late String _category;
  late String _glutenStatus;

  bool get _isEditing => widget.existingFood != null;

  /// Whether the calorie field was last set by auto-calculation.
  bool _caloriesAutoCalculated = false;

  void _recalcCalories() {
    final p = double.tryParse(_proteinController.text.trim());
    final c = double.tryParse(_carbsController.text.trim());
    final f = double.tryParse(_fatController.text.trim());
    if (p != null && c != null && f != null) {
      final auto = (p * 4 + c * 4 + f * 9).roundToDouble();
      _caloriesController.text = auto.toStringAsFixed(0);
      if (mounted) setState(() => _caloriesAutoCalculated = true);
    }
  }

  @override
  void initState() {
    super.initState();
    final food = widget.existingFood;

    _nameController = TextEditingController(text: food?.name ?? '');
    _brandController = TextEditingController(text: food?.brand ?? '');
    _caloriesController = TextEditingController(
        text: food != null ? food.caloriesPer100g.toString() : '');
    _proteinController = TextEditingController(
        text: food != null ? food.proteinPer100g.toString() : '');
    _carbsController = TextEditingController(
        text: food != null ? food.carbsPer100g.toString() : '');
    _fatController = TextEditingController(
        text: food != null ? food.fatPer100g.toString() : '');
    _fiberController = TextEditingController(
        text: food?.fiberPer100g?.toString() ?? '');
    _sugarController = TextEditingController(
        text: food?.sugarPer100g?.toString() ?? '');
    _sodiumController = TextEditingController(
        text: food?.sodiumPer100mg?.toString() ?? '');
    _servingGController = TextEditingController(
        text: food != null ? food.defaultServingG.toString() : '100');
    _servingDescController =
        TextEditingController(text: food?.servingDescription ?? '');

    _category = food?.category ?? _foodCategories.first;
    _glutenStatus = food?.glutenStatus ?? 'unknown';

    // Auto-calculate calories whenever any macro field changes.
    _proteinController.addListener(_recalcCalories);
    _carbsController.addListener(_recalcCalories);
    _fatController.addListener(_recalcCalories);
    // If the user manually edits calories, clear the auto flag.
    _caloriesController.addListener(() {
      // Only clear the flag when the user is the source of the change
      // (i.e. the field was focused). We rely on the fact that
      // _recalcCalories sets the text programmatically — that also fires
      // this listener, so we gate on _caloriesAutoCalculated to avoid
      // clearing the flag we just set.
      if (!_caloriesAutoCalculated) return;
      _caloriesAutoCalculated = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    _servingGController.dispose();
    _servingDescController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final db = ref.read(appDatabaseProvider);

    final entry = FoodsCompanion(
      name: Value(_nameController.text.trim()),
      brand: Value(_brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim()),
      category: Value(_category),
      caloriesPer100g: Value(double.parse(_caloriesController.text.trim())),
      proteinPer100g: Value(
          double.tryParse(_proteinController.text.trim()) ?? 0),
      carbsPer100g:
          Value(double.tryParse(_carbsController.text.trim()) ?? 0),
      fatPer100g:
          Value(double.tryParse(_fatController.text.trim()) ?? 0),
      fiberPer100g: Value(
          double.tryParse(_fiberController.text.trim())),
      sugarPer100g: Value(
          double.tryParse(_sugarController.text.trim())),
      sodiumPer100mg: Value(
          double.tryParse(_sodiumController.text.trim())),
      defaultServingG: Value(
          double.tryParse(_servingGController.text.trim()) ?? 100),
      servingDescription: Value(_servingDescController.text.trim().isEmpty
          ? null
          : _servingDescController.text.trim()),
      glutenStatus: Value(_glutenStatus),
      isCustom: const Value(1),
    );

    try {
      if (_isEditing) {
        await db.foodsDao.updateCustomFood(widget.existingFood!.id, entry);
      } else {
        await db.foodsDao.insertCustomFood(entry);
      }

      // Invalidate search results so the new/updated food appears.
      ref.invalidate(foodSearchProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Custom food updated'
                : 'Custom food added'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _importCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.isEmpty) return;

    final filePath = result.files.single.path;
    if (filePath == null) return;

    final file = File(filePath);
    final content = await file.readAsString();
    final lines = const LineSplitter().convert(content);

    if (lines.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV file is empty')),
        );
      }
      return;
    }

    // Parse header row.
    final headers =
        lines.first.split(',').map((h) => h.trim().toLowerCase()).toList();

    final nameIdx = headers.indexOf('name');
    final categoryIdx = headers.indexOf('category');
    final caloriesIdx = headers.indexOf('calories_per_100g');
    final proteinIdx = headers.indexOf('protein_per_100g');
    final carbsIdx = headers.indexOf('carbs_per_100g');
    final fatIdx = headers.indexOf('fat_per_100g');
    final fiberIdx = headers.indexOf('fiber_per_100g');
    final sugarIdx = headers.indexOf('sugar_per_100g');
    final sodiumIdx = headers.indexOf('sodium_per_100mg');
    final servingGIdx = headers.indexOf('default_serving_g');
    final servingDescIdx = headers.indexOf('serving_description');
    final glutenIdx = headers.indexOf('gluten_status');

    if (nameIdx == -1 || caloriesIdx == -1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'CSV must have "name" and "calories_per_100g" columns')),
        );
      }
      return;
    }

    final entries = <FoodsCompanion>[];
    var skipped = 0;

    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final cols = _parseCsvLine(line);

      final name =
          nameIdx < cols.length ? cols[nameIdx].trim() : '';
      final caloriesStr =
          caloriesIdx < cols.length ? cols[caloriesIdx].trim() : '';
      final calories = double.tryParse(caloriesStr);

      if (name.isEmpty || calories == null) {
        skipped++;
        continue;
      }

      String col(int idx) =>
          idx >= 0 && idx < cols.length ? cols[idx].trim() : '';

      final glutenStatusRaw = col(glutenIdx);
      final glutenStatusValue =
          _glutenStatusOptions.contains(glutenStatusRaw)
              ? glutenStatusRaw
              : 'unknown';

      entries.add(FoodsCompanion(
        name: Value(name),
        brand: const Value(null),
        category: Value(
            col(categoryIdx).isNotEmpty ? col(categoryIdx) : 'Snacks'),
        caloriesPer100g: Value(calories),
        proteinPer100g:
            Value(double.tryParse(col(proteinIdx)) ?? 0),
        carbsPer100g:
            Value(double.tryParse(col(carbsIdx)) ?? 0),
        fatPer100g: Value(double.tryParse(col(fatIdx)) ?? 0),
        fiberPer100g:
            Value(double.tryParse(col(fiberIdx))),
        sugarPer100g:
            Value(double.tryParse(col(sugarIdx))),
        sodiumPer100mg:
            Value(double.tryParse(col(sodiumIdx))),
        defaultServingG:
            Value(double.tryParse(col(servingGIdx)) ?? 100),
        servingDescription: Value(
            col(servingDescIdx).isNotEmpty ? col(servingDescIdx) : null),
        glutenStatus: Value(glutenStatusValue),
        isCustom: const Value(1),
      ));
    }

    if (entries.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No valid rows found ($skipped skipped)')),
        );
      }
      return;
    }

    final db = ref.read(appDatabaseProvider);
    await db.foodsDao.insertCustomFoods(entries);
    ref.invalidate(foodSearchProvider);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('CSV Import Complete'),
          content: Text(
            '${entries.length} food(s) imported'
            '${skipped > 0 ? ', $skipped row(s) skipped' : ''}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  /// Naive CSV line parser that handles quoted fields.
  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(ch);
      }
    }
    result.add(buffer.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Custom Food' : 'Add Custom Food'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: 'Import CSV',
              onPressed: _importCsv,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Name ──────────────────────────────────────────────
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Food Name *',
                hintText: 'e.g. Quinoa Salad',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),

            // ── Brand ─────────────────────────────────────────────
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand (optional)',
                hintText: 'e.g. Organic Valley',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),

            // ── Category ──────────────────────────────────────────
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category *'),
              items: _foodCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _category = v);
              },
            ),
            const SizedBox(height: 12),

            // ── Gluten status ─────────────────────────────────────
            DropdownButtonFormField<String>(
              initialValue: _glutenStatus,
              decoration: const InputDecoration(labelText: 'Gluten Status *'),
              items: _glutenStatusOptions.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Row(
                    children: [
                      GlutenBadge(glutenStatus: s),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _glutenStatus = v);
              },
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Gluten status is required' : null,
            ),

            // Show gluten warning if risky status selected
            if (GlutenUtils.isRiskyString(_glutenStatus)) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GlutenUtils.badgeColorFromString(_glutenStatus, context)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      GlutenUtils.badgeIcon(
                          GlutenStatus.fromString(_glutenStatus)),
                      color: GlutenUtils.badgeColorFromString(
                          _glutenStatus, context),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This food will be flagged with a gluten warning.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: GlutenUtils.badgeColorFromString(
                              _glutenStatus, context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // ── Nutrition section ─────────────────────────────────
            Text('Nutrition per 100g',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _NumericField(
                    controller: _caloriesController,
                    label: 'Calories (kcal) *',
                    isRequired: true,
                  ),
                ),
                if (_caloriesAutoCalculated) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Tooltip(
                      message: 'Calculated from Protein × 4 + Carbs × 4 + Fat × 9',
                      child: Chip(
                        label: const Text('Auto'),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _NumericField(
                    controller: _proteinController,
                    label: 'Protein (g)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumericField(
                    controller: _carbsController,
                    label: 'Carbs (g)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumericField(
                    controller: _fatController,
                    label: 'Fat (g)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _NumericField(
                    controller: _fiberController,
                    label: 'Fiber (g)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumericField(
                    controller: _sugarController,
                    label: 'Sugar (g)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumericField(
                    controller: _sodiumController,
                    label: 'Sodium (mg)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Serving section ───────────────────────────────────
            Text('Default Serving', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _NumericField(
                    controller: _servingGController,
                    label: 'Serving size (g)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _servingDescController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'e.g. 1 cup',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Save button ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_isEditing ? 'Update Food' : 'Save Food'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Numeric text field with decimal support.
class _NumericField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;

  const _NumericField({
    required this.controller,
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      decoration: InputDecoration(labelText: label),
      validator: isRequired
          ? (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (double.tryParse(v.trim()) == null) return 'Invalid number';
              return null;
            }
          : null,
    );
  }
}
