// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:calorie_tracker/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase.forTesting(
              schema.newConnection(),
              skipSeeding: true,
            );
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  group('v1 to v2 data integrity', () {
    test('seeded food rows survive migration and gain null seed_key', () async {
      // 1. Stand up a v1 database and insert sample data.
      final schema = await verifier.schemaAt(1);

      final oldFoodsData = <v1.FoodsData>[
        v1.FoodsData(
          id: 1,
          name: 'Banana',
          brand: null,
          category: 'fruit',
          caloriesPer100g: 89.0,
          proteinPer100g: 1.1,
          carbsPer100g: 23.0,
          fatPer100g: 0.3,
          fiberPer100g: 2.6,
          sugarPer100g: 12.2,
          sodiumPer100mg: null,
          defaultServingG: 120.0,
          servingDescription: '1 medium',
          isGlutenFree: 1,
          glutenStatus: 'gluten_free',
          isCustom: 0,
        ),
        v1.FoodsData(
          id: 2,
          name: 'Wheat Bread',
          brand: 'BreadCo',
          category: 'bakery',
          caloriesPer100g: 265.0,
          proteinPer100g: 9.0,
          carbsPer100g: 49.0,
          fatPer100g: 3.2,
          fiberPer100g: 2.7,
          sugarPer100g: 5.0,
          sodiumPer100mg: null,
          defaultServingG: 30.0,
          servingDescription: '1 slice',
          isGlutenFree: 0,
          glutenStatus: 'contains_gluten',
          isCustom: 0,
        ),
        // A custom food — must survive migration with seed_key remaining null.
        v1.FoodsData(
          id: 3,
          name: 'My Protein Shake',
          brand: null,
          category: 'custom',
          caloriesPer100g: 120.0,
          proteinPer100g: 25.0,
          carbsPer100g: 5.0,
          fatPer100g: 1.0,
          fiberPer100g: null,
          sugarPer100g: null,
          sodiumPer100mg: null,
          defaultServingG: 300.0,
          servingDescription: '1 scoop',
          isGlutenFree: 1,
          glutenStatus: 'unknown',
          isCustom: 1,
        ),
      ];

      final oldFoodLogsData = <v1.FoodLogsData>[
        v1.FoodLogsData(
          id: 1,
          date: '2026-04-16',
          mealType: 'breakfast',
          foodId: 1,
          quantityG: 120.0,
          calories: 106.8,
          protein: 1.32,
          carbs: 27.6,
          fat: 0.36,
          glutenStatus: 'gluten_free',
          loggedAt: '2026-04-16T08:00:00',
        ),
      ];

      final oldUserProfileData = <v1.UserProfileData>[
        v1.UserProfileData(
          id: 1,
          name: 'Test User',
          dateOfBirth: '1990-01-01',
          gender: 'male',
          heightCm: 175.0,
          weightKg: 70.0,
          activityLevel: 'moderately_active',
          goalType: 'maintain',
          calorieTarget: 2500.0,
          proteinTargetG: 156.25,
          carbsTargetG: 312.5,
          fatTargetG: 69.4,
          waterTargetMl: 2500,
          isGlutenFree: 1,
          dbVersion: 1,
          onboardingComplete: 1,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 1,
        newVersion: 2,
        createOld: v1.DatabaseAtV1.new,
        createNew: v2.DatabaseAtV2.new,
        openTestedDatabase: (e) =>
            AppDatabase.forTesting(e, skipSeeding: true),
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.foods, oldFoodsData);
          batch.insertAll(oldDb.foodLogs, oldFoodLogsData);
          batch.insertAll(oldDb.userProfile, oldUserProfileData);
        },
        validateItems: (newDb) async {
          // -- Foods: all three rows must survive.
          final foods = await newDb.select(newDb.foods).get();
          expect(foods.length, 3);

          // Seeded rows now have seed_key backfilled by the migration.
          // Custom row keeps seed_key = null.
          final banana = foods.firstWhere((f) => f.name == 'Banana');
          expect(banana.seedKey, isNotNull,
              reason: 'seeded food should get seed_key from migration');

          final bread = foods.firstWhere((f) => f.name == 'Wheat Bread');
          expect(bread.seedKey, isNotNull);

          final shake = foods.firstWhere((f) => f.name == 'My Protein Shake');
          expect(shake.seedKey, isNull,
              reason: 'custom food keeps seed_key = null');

          // Core nutritional data must be preserved exactly.
          expect(banana.caloriesPer100g, 89.0);
          expect(banana.proteinPer100g, 1.1);
          expect(bread.glutenStatus, 'contains_gluten');
          expect(shake.isCustom, 1);

          // -- FoodLogs: must survive untouched.
          final logs = await newDb.select(newDb.foodLogs).get();
          expect(logs.length, 1);
          expect(logs.first.foodId, 1);
          expect(logs.first.calories, 106.8);
          expect(logs.first.glutenStatus, 'gluten_free');

          // -- UserProfile: must survive untouched.
          final profiles = await newDb.select(newDb.userProfile).get();
          expect(profiles.length, 1);
          expect(profiles.first.name, 'Test User');
          expect(profiles.first.isGlutenFree, 1);
          expect(profiles.first.onboardingComplete, 1);

          // -- Metadata table: must exist (created by migration).
          final metaRows = await newDb.select(newDb.metadata).get();
          // The migration writes seed_version = 1 into metadata.
          expect(
            metaRows.any((m) => m.key == 'seed_version'),
            isTrue,
            reason: 'v1→v2 migration must write seed_version to metadata',
          );
          final seedVersionRow =
              metaRows.firstWhere((m) => m.key == 'seed_version');
          expect(seedVersionRow.value, '1');
        },
      );
    });

    test('empty v1 database migrates to v2 cleanly', () async {
      // Edge case: a fresh v1 install that was never seeded.
      final schema = await verifier.schemaAt(1);
      final db = AppDatabase.forTesting(
        schema.newConnection(),
        skipSeeding: true,
      );
      await verifier.migrateAndValidate(db, 2);

      // Metadata table exists and has seed_version = 1.
      final metaRows = await db.select(db.metadata).get();
      expect(
        metaRows.any((m) => m.key == 'seed_version'),
        isTrue,
      );

      await db.close();
    });

    test('food_logs with gluten data survive migration', () async {
      final schema = await verifier.schemaAt(1);

      // Insert a food and a log referencing it with gluten status.
      final oldFoodsData = <v1.FoodsData>[
        v1.FoodsData(
          id: 1,
          name: 'Oat Cookie',
          brand: null,
          category: 'snack',
          caloriesPer100g: 400.0,
          proteinPer100g: 6.0,
          carbsPer100g: 60.0,
          fatPer100g: 15.0,
          fiberPer100g: null,
          sugarPer100g: null,
          sodiumPer100mg: null,
          defaultServingG: 30.0,
          servingDescription: '1 cookie',
          isGlutenFree: 0,
          glutenStatus: 'may_contain',
          isCustom: 0,
        ),
      ];

      final oldFoodLogsData = <v1.FoodLogsData>[
        v1.FoodLogsData(
          id: 1,
          date: '2026-04-16',
          mealType: 'snacks',
          foodId: 1,
          quantityG: 30.0,
          calories: 120.0,
          protein: 1.8,
          carbs: 18.0,
          fat: 4.5,
          glutenStatus: 'may_contain',
          loggedAt: '2026-04-16T15:00:00',
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 1,
        newVersion: 2,
        createOld: v1.DatabaseAtV1.new,
        createNew: v2.DatabaseAtV2.new,
        openTestedDatabase: (e) =>
            AppDatabase.forTesting(e, skipSeeding: true),
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.foods, oldFoodsData);
          batch.insertAll(oldDb.foodLogs, oldFoodLogsData);
        },
        validateItems: (newDb) async {
          // The gluten status on food_logs must be preserved exactly — this is
          // critical for the user's strict gluten-free dietary tracking.
          final logs = await newDb.select(newDb.foodLogs).get();
          expect(logs.length, 1);
          expect(logs.first.glutenStatus, 'may_contain');

          // The food's gluten_status and is_gluten_free must survive too.
          final foods = await newDb.select(newDb.foods).get();
          expect(foods.first.glutenStatus, 'may_contain');
          expect(foods.first.isGlutenFree, 0);
        },
      );
    });
  });
}
