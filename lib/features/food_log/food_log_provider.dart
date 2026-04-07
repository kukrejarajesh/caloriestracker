import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';

part 'food_log_provider.g.dart';

// ── Gluten filter toggle (session-scoped) ─────────────────────────────────────

@riverpod
class GlutenFilterNotifier extends _$GlutenFilterNotifier {
  @override
  bool build() => true; // always defaults ON per CLAUDE.md

  void toggle() => state = !state;
  void set(bool v) => state = v;
}

// ── Search query ──────────────────────────────────────────────────────────────

@riverpod
class SearchQueryNotifier extends _$SearchQueryNotifier {
  @override
  String build() => '';

  void set(String v) => state = v;
}

// ── Food search results ───────────────────────────────────────────────────────

@riverpod
Future<List<Food>> foodSearch(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = ref.watch(searchQueryNotifierProvider);
  final glutenFreeOnly = ref.watch(glutenFilterNotifierProvider);

  return db.foodsDao.searchFoods(query, glutenFreeOnly: glutenFreeOnly);
}

// ── Selected meal type ────────────────────────────────────────────────────────

@riverpod
class MealTypeNotifier extends _$MealTypeNotifier {
  @override
  String build() => 'breakfast';

  void set(String v) => state = v;
}

// ── Food log notifier ─────────────────────────────────────────────────────────

class FoodLogState {
  final bool isLogging;
  final String? error;
  final bool success;

  const FoodLogState({
    this.isLogging = false,
    this.error,
    this.success = false,
  });

  FoodLogState copyWith({bool? isLogging, String? error, bool? success}) =>
      FoodLogState(
        isLogging: isLogging ?? this.isLogging,
        error: error,
        success: success ?? this.success,
      );
}

@riverpod
class FoodLogNotifier extends _$FoodLogNotifier {
  @override
  FoodLogState build() => const FoodLogState();

  /// Logs [food] to [mealType] for [date] with [quantityG] grams.
  Future<bool> logFood({
    required Food food,
    required String mealType,
    required String date,
    required double quantityG,
  }) async {
    state = state.copyWith(isLogging: true, error: null, success: false);

    try {
      final db = ref.read(appDatabaseProvider);
      final ratio = quantityG / 100.0;

      await db.foodLogsDao.insertLog(
        FoodLogsCompanion(
          date: Value(date),
          mealType: Value(mealType),
          foodId: Value(food.id),
          quantityG: Value(quantityG),
          calories: Value(food.caloriesPer100g * ratio),
          protein: Value(food.proteinPer100g * ratio),
          carbs: Value(food.carbsPer100g * ratio),
          fat: Value(food.fatPer100g * ratio),
          glutenStatus: Value(food.glutenStatus),
          loggedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

      state = state.copyWith(isLogging: false, success: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLogging: false, error: e.toString());
      return false;
    }
  }
}
