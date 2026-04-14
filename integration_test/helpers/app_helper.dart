import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:calorie_tracker/app.dart';
import 'package:calorie_tracker/data/database/app_database.dart';

export 'package:calorie_tracker/data/database/app_database.dart';

/// Creates a fresh in-memory Drift database for each test.
AppDatabase createTestDb() => AppDatabase.forTesting(NativeDatabase.memory());

/// Seeds 3 foods with known names and gluten statuses.
/// Tests search by these exact names: 'Apple', 'Oat Biscuit', 'White Bread'.
Future<void> seedTestFoods(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.foods, [
      FoodsCompanion.insert(
        name: 'Apple',
        category: 'Fruit',
        caloriesPer100g: 52,
        proteinPer100g: const Value(0.3),
        carbsPer100g: const Value(14),
        fatPer100g: const Value(0.2),
        glutenStatus: const Value('gluten_free'),
        isCustom: const Value(0),
      ),
      FoodsCompanion.insert(
        name: 'Oat Biscuit',
        category: 'Snacks',
        caloriesPer100g: 450,
        proteinPer100g: const Value(7),
        carbsPer100g: const Value(65),
        fatPer100g: const Value(18),
        glutenStatus: const Value('may_contain'),
        isCustom: const Value(0),
      ),
      FoodsCompanion.insert(
        name: 'White Bread',
        category: 'Grains',
        caloriesPer100g: 265,
        proteinPer100g: const Value(9),
        carbsPer100g: const Value(49),
        fatPer100g: const Value(3),
        glutenStatus: const Value('contains_gluten'),
        isCustom: const Value(0),
      ),
    ]);
  });
}

/// Seeds one exercise.
Future<void> seedTestExercises(AppDatabase db) async {
  await db.into(db.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Walking',
          category: 'Cardio',
          metValue: 3.5,
          description: const Value('Brisk walking'),
        ),
      );
}

/// Seeds a completed user profile so the app skips onboarding and opens Dashboard.
Future<void> seedCompletedProfile(AppDatabase db) async {
  await db.into(db.userProfile).insert(
        UserProfileCompanion(
          id: const Value(1),
          name: const Value('Test User'),
          dateOfBirth: const Value('1990-01-01'),
          gender: const Value('male'),
          heightCm: const Value(175.0),
          weightKg: const Value(70.0),
          activityLevel: const Value('moderately_active'),
          goalType: const Value('maintain'),
          calorieTarget: const Value(2500.0),
          proteinTargetG: const Value(150.0),
          carbsTargetG: const Value(300.0),
          fatTargetG: const Value(80.0),
          waterTargetMl: const Value(2000),
          isGlutenFree: const Value(1),
          onboardingComplete: const Value(1),
        ),
        mode: InsertMode.insertOrReplace,
      );
}

/// Pumps the app with [db] injected via ProviderScope override.
/// Uses pump(500ms) × 2 instead of pumpAndSettle to avoid hanging on
/// the dashboardProvider Drift stream that never completes.
Future<void> pumpApp(WidgetTester tester, AppDatabase db) async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const CalorieTrackerApp(),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

/// Taps a bottom nav item by its label text.
/// Uses .hitTestable() to avoid hitting the non-visible screen's label.
Future<void> tapBottomNav(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.text(label),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}
