// ignore_for_file: lines_longer_than_80_chars

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/data/database/app_database.dart';

/// Helper — inserts a minimal food row into the in-memory DB and returns its
/// generated id.
Future<int> _insertFood(
  AppDatabase db, {
  required String name,
  required String glutenStatus,
  String category = 'general',
  double caloriesPer100g = 100,
}) {
  return db.foodsDao.insertCustomFood(
    FoodsCompanion.insert(
      name: name,
      category: category,
      caloriesPer100g: caloriesPer100g,
      glutenStatus: Value(glutenStatus),
      isCustom: const Value(1),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(),
      skipSeeding: true,
    );
  });

  tearDown(() async {
    await db.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Gluten safety — the highest-priority tests in the entire suite
  // ═══════════════════════════════════════════════════════════════════════════

  group('gluten safety — searchFoods', () {
    setUp(() async {
      // Seed one food of each gluten status.
      await _insertFood(db, name: 'Brown Rice', glutenStatus: 'gluten_free');
      await _insertFood(db, name: 'Wheat Bread', glutenStatus: 'contains_gluten');
      await _insertFood(db, name: 'Oats (shared facility)', glutenStatus: 'may_contain');
      await _insertFood(db, name: 'Mystery Spice Blend', glutenStatus: 'unknown');
    });

    test('search with gluten filter on never returns contains_gluten foods', () async {
      final results = await db.foodsDao.searchFoods('', glutenFreeOnly: true);
      expect(
        results.any((f) => f.glutenStatus == 'contains_gluten'),
        isFalse,
        reason: 'contains_gluten food must never appear when glutenFreeOnly=true',
      );
    });

    test('search with gluten filter on never returns may_contain foods', () async {
      final results = await db.foodsDao.searchFoods('', glutenFreeOnly: true);
      expect(
        results.any((f) => f.glutenStatus == 'may_contain'),
        isFalse,
        reason: 'may_contain food must never appear when glutenFreeOnly=true',
      );
    });

    test('search with gluten filter on never returns unknown gluten status foods', () async {
      final results = await db.foodsDao.searchFoods('', glutenFreeOnly: true);
      expect(
        results.any((f) => f.glutenStatus == 'unknown'),
        isFalse,
        reason: 'unknown gluten status must be treated as risky — must not appear when glutenFreeOnly=true',
      );
    });

    test('search with gluten filter on does return gluten_free foods', () async {
      final results = await db.foodsDao.searchFoods('Brown Rice', glutenFreeOnly: true);
      expect(results, hasLength(1));
      expect(results.first.glutenStatus, equals('gluten_free'));
    });

    test('search with gluten filter off returns all four gluten statuses', () async {
      final results = await db.foodsDao.searchFoods('', glutenFreeOnly: false);
      final statuses = results.map((f) => f.glutenStatus).toSet();
      expect(statuses, containsAll(['gluten_free', 'contains_gluten', 'may_contain', 'unknown']));
    });

    test('default parameter for glutenFreeOnly is true — unfiltered call excludes unsafe foods', () async {
      // Call with no named argument — relies on the default.
      final results = await db.foodsDao.searchFoods('');
      expect(
        results.every((f) => f.glutenStatus == 'gluten_free'),
        isTrue,
        reason: 'Without explicit glutenFreeOnly argument the default must be true',
      );
    });

    test('search with gluten filter on returns only the gluten_free food among all seeds', () async {
      final results = await db.foodsDao.searchFoods('', glutenFreeOnly: true);
      expect(results, hasLength(1));
      expect(results.first.name, equals('Brown Rice'));
    });

    test('watchFoods default emits only gluten_free items', () async {
      final first = await db.foodsDao.watchFoods().first;
      expect(
        first.every((f) => f.glutenStatus == 'gluten_free'),
        isTrue,
      );
    });

    test('watchFoods with glutenFreeOnly false emits all items', () async {
      final first = await db.foodsDao.watchFoods(glutenFreeOnly: false).first;
      expect(first.length, equals(4));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // searchFoods — functional behaviour
  // ═══════════════════════════════════════════════════════════════════════════

  group('searchFoods — name matching', () {
    setUp(() async {
      await _insertFood(db, name: 'Apple', glutenStatus: 'gluten_free');
      await _insertFood(db, name: 'Applesauce', glutenStatus: 'gluten_free');
      await _insertFood(db, name: 'Banana', glutenStatus: 'gluten_free');
    });

    test('LIKE search returns all foods whose name contains the query substring', () async {
      final results = await db.foodsDao.searchFoods('Apple', glutenFreeOnly: false);
      expect(results.map((f) => f.name), containsAll(['Apple', 'Applesauce']));
      expect(results.any((f) => f.name == 'Banana'), isFalse);
    });

    test('empty query string returns all foods (respecting gluten filter)', () async {
      final results = await db.foodsDao.searchFoods('', glutenFreeOnly: false);
      expect(results, hasLength(3));
    });

    test('query with no match returns empty list', () async {
      final results = await db.foodsDao.searchFoods('Zucchini', glutenFreeOnly: false);
      expect(results, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // getFoodById
  // ═══════════════════════════════════════════════════════════════════════════

  group('getFoodById', () {
    test('returns the correct food when it exists', () async {
      final id = await _insertFood(db, name: 'Quinoa', glutenStatus: 'gluten_free');
      final food = await db.foodsDao.getFoodById(id);
      expect(food, isNotNull);
      expect(food!.name, equals('Quinoa'));
      expect(food.glutenStatus, equals('gluten_free'));
    });

    test('returns null when food does not exist', () async {
      final food = await db.foodsDao.getFoodById(9999);
      expect(food, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // insertCustomFood — gluten defaults
  // ═══════════════════════════════════════════════════════════════════════════

  group('insertCustomFood', () {
    test('custom food with explicit gluten_free status is stored correctly', () async {
      final id = await _insertFood(db, name: 'Homemade Rice Cake', glutenStatus: 'gluten_free');
      final food = await db.foodsDao.getFoodById(id);
      expect(food!.glutenStatus, equals('gluten_free'));
      expect(food.isCustom, equals(1));
    });

    test('custom food defaults to unknown gluten status when none supplied', () async {
      // Insert using minimum required fields — glutenStatus uses table default.
      final id = await db.foodsDao.insertCustomFood(
        FoodsCompanion.insert(
          name: 'My Secret Sauce',
          category: 'sauces',
          caloriesPer100g: 80,
          isCustom: const Value(1),
        ),
      );
      final food = await db.foodsDao.getFoodById(id);
      // The table default is 'unknown', so it must never be null.
      expect(food!.glutenStatus, equals('unknown'));
    });

    test('custom food with unknown status does not appear in gluten-filtered search', () async {
      await db.foodsDao.insertCustomFood(
        FoodsCompanion.insert(
          name: 'Unknown Grain Mix',
          category: 'grains',
          caloriesPer100g: 200,
          isCustom: const Value(1),
        ),
      );
      final filtered = await db.foodsDao.searchFoods('Unknown Grain Mix', glutenFreeOnly: true);
      expect(filtered, isEmpty, reason: 'unknown status must be excluded by gluten filter');
    });
  });
}
