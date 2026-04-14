// ignore_for_file: lines_longer_than_80_chars

import 'package:drift/drift.dart' show Value, FoodsCompanion, FoodLogsCompanion;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/data/database/app_database.dart';
import 'package:calorie_tracker/data/tables/foods_table.dart';
import 'package:calorie_tracker/data/tables/food_logs_table.dart';

/// Inserts a minimal food and returns its id.
Future<int> _seedFood(AppDatabase db,
    {String name = 'Test Food',
    String glutenStatus = 'gluten_free',
    double calories = 200}) {
  return db.foodsDao.insertCustomFood(
    FoodsCompanion.insert(
      name: name,
      category: 'test',
      caloriesPer100g: calories,
      glutenStatus: Value(glutenStatus),
      isCustom: const Value(1),
    ),
  );
}

/// Inserts a food log entry and returns its id.
Future<int> _insertLog(
  AppDatabase db, {
  required int foodId,
  required String date,
  String mealType = 'lunch',
  double quantityG = 100,
  double calories = 200,
  double protein = 10,
  double carbs = 30,
  double fat = 5,
  String glutenStatus = 'gluten_free',
}) {
  return db.foodLogsDao.insertLog(
    FoodLogsCompanion.insert(
      date: date,
      mealType: mealType,
      foodId: foodId,
      quantityG: quantityG,
      calories: calories,
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      glutenStatus: Value(glutenStatus),
      loggedAt: DateTime.now().toIso8601String(),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Gluten safety assertion — food logs preserve gluten status
  // ═══════════════════════════════════════════════════════════════════════════

  group('gluten safety — food log records preserve gluten status', () {
    test('log entry with contains_gluten status is stored and readable', () async {
      final foodId = await _seedFood(db, glutenStatus: 'contains_gluten');
      await _insertLog(db, foodId: foodId, date: '2024-01-01', glutenStatus: 'contains_gluten');

      final logs = await db.foodLogsDao.getLogsForDate('2024-01-01');
      expect(logs, hasLength(1));
      expect(
        logs.first.glutenStatus,
        equals('contains_gluten'),
        reason: 'Gluten status must survive the insert-read round trip so the UI can flag risky items',
      );
    });

    test('log entry with gluten_free status is stored correctly', () async {
      final foodId = await _seedFood(db, glutenStatus: 'gluten_free');
      await _insertLog(db, foodId: foodId, date: '2024-01-02', glutenStatus: 'gluten_free');

      final logs = await db.foodLogsDao.getLogsForDate('2024-01-02');
      expect(logs.first.glutenStatus, equals('gluten_free'));
    });

    test('log entry with unknown gluten status is stored and treated as risky', () async {
      final foodId = await _seedFood(db, glutenStatus: 'unknown');
      await _insertLog(db, foodId: foodId, date: '2024-01-03', glutenStatus: 'unknown');

      final logs = await db.foodLogsDao.getLogsForDate('2024-01-03');
      expect(logs.first.glutenStatus, equals('unknown'),
          reason: 'unknown status must be preserved so the dashboard can flag it');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // getLogsForDate / watchLogsForDate
  // ═══════════════════════════════════════════════════════════════════════════

  group('getLogsForDate', () {
    test('returns only logs for the requested date', () async {
      final foodId = await _seedFood(db);
      await _insertLog(db, foodId: foodId, date: '2024-03-01');
      await _insertLog(db, foodId: foodId, date: '2024-03-02');
      await _insertLog(db, foodId: foodId, date: '2024-03-01', mealType: 'breakfast');

      final logs = await db.foodLogsDao.getLogsForDate('2024-03-01');
      expect(logs, hasLength(2));
      expect(logs.every((l) => l.date == '2024-03-01'), isTrue);
    });

    test('returns empty list when no logs exist for date', () async {
      final logs = await db.foodLogsDao.getLogsForDate('2099-12-31');
      expect(logs, isEmpty);
    });
  });

  group('watchLogsForDate', () {
    test('stream emits current logs for a date', () async {
      final foodId = await _seedFood(db);
      await _insertLog(db, foodId: foodId, date: '2024-06-15', mealType: 'dinner');

      final logs = await db.foodLogsDao.watchLogsForDate('2024-06-15').first;
      expect(logs, hasLength(1));
      expect(logs.first.mealType, equals('dinner'));
    });

    test('stream emits updated list after new log is inserted', () async {
      final foodId = await _seedFood(db);
      const date = '2024-07-20';

      final stream = db.foodLogsDao.watchLogsForDate(date);
      // Insert after the stream is set up.
      await _insertLog(db, foodId: foodId, date: date);

      final logs = await stream.first;
      expect(logs, hasLength(1));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // insertLog / deleteLog
  // ═══════════════════════════════════════════════════════════════════════════

  group('insertLog and deleteLog', () {
    test('inserted log is retrievable', () async {
      final foodId = await _seedFood(db);
      final logId = await _insertLog(
        db,
        foodId: foodId,
        date: '2024-05-10',
        mealType: 'breakfast',
        calories: 350,
        protein: 20,
        carbs: 45,
        fat: 8,
      );

      final logs = await db.foodLogsDao.getLogsForDate('2024-05-10');
      expect(logs, hasLength(1));
      final log = logs.first;
      expect(log.id, equals(logId));
      expect(log.calories, closeTo(350, 0.001));
      expect(log.protein, closeTo(20, 0.001));
      expect(log.mealType, equals('breakfast'));
    });

    test('deleteLog removes the correct entry', () async {
      final foodId = await _seedFood(db);
      const date = '2024-08-01';
      final idToDelete = await _insertLog(db, foodId: foodId, date: date, mealType: 'breakfast');
      await _insertLog(db, foodId: foodId, date: date, mealType: 'lunch');

      final deletedCount = await db.foodLogsDao.deleteLog(idToDelete);
      expect(deletedCount, equals(1));

      final remaining = await db.foodLogsDao.getLogsForDate(date);
      expect(remaining, hasLength(1));
      expect(remaining.first.mealType, equals('lunch'));
    });

    test('deleting a non-existent log id affects zero rows', () async {
      final count = await db.foodLogsDao.deleteLog(9999);
      expect(count, equals(0));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // updateLog
  // ═══════════════════════════════════════════════════════════════════════════

  group('updateLog', () {
    test('calories are updated correctly', () async {
      final foodId = await _seedFood(db);
      const date = '2024-09-01';
      final id = await _insertLog(db, foodId: foodId, date: date, calories: 200);

      final logs = await db.foodLogsDao.getLogsForDate(date);
      final original = logs.first;

      final updated = FoodLogsCompanion(
        id: Value(original.id),
        date: Value(original.date),
        mealType: Value(original.mealType),
        foodId: Value(original.foodId),
        quantityG: Value(original.quantityG),
        calories: const Value(350),
        protein: Value(original.protein),
        carbs: Value(original.carbs),
        fat: Value(original.fat),
        glutenStatus: Value(original.glutenStatus),
        loggedAt: Value(original.loggedAt),
      );

      final success = await db.foodLogsDao.updateLog(updated);
      expect(success, isTrue);

      final after = await db.foodLogsDao.getLogsForDate(date);
      expect(after.first.calories, closeTo(350, 0.001));
      expect(after.first.id, equals(id));
    });
  });
}
