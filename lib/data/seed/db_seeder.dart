import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import '../database/app_database.dart';

/// Seeds foods and exercises from bundled asset databases into the main
/// [AppDatabase] on first launch (called from [MigrationStrategy.onCreate]).
class DbSeeder {
  DbSeeder._();

  static const _foodsAsset = 'assets/foods.db';
  static const _exercisesAsset = 'assets/exercises.db';

  /// Called from [AppDatabase.migration] onCreate — reads the bundled asset DBs
  /// and inserts all rows into the already-created Drift tables.
  static Future<void> seedInto(AppDatabase db) async {
    await _seedFoods(db);
    await _seedExercises(db);
  }

  /// Copies an asset to a temporary file so sqlite3 can open it, then returns
  /// the temp path. Caller must delete the file when done.
  static Future<String> _assetToTempFile(String assetPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final tempPath = p.join(dir.path, 'temp_${p.basename(assetPath)}');
    final data = await rootBundle.load(assetPath);
    await File(tempPath).writeAsBytes(
      data.buffer.asUint8List(),
      flush: true,
    );
    return tempPath;
  }

  static Future<void> _seedFoods(AppDatabase db) async {
    final tempPath = await _assetToTempFile(_foodsAsset);
    try {
      final seedDb = raw.sqlite3.open(tempPath);
      final result = seedDb.select('SELECT * FROM foods');
      debugPrint('DbSeeder: loading ${result.length} foods from asset');

      await db.batch((batch) {
        for (final row in result) {
          batch.insert(
            db.foods,
            FoodsCompanion.insert(
              name: row['name'] as String,
              brand: Value(row['brand'] as String?),
              category: row['category'] as String,
              caloriesPer100g: (row['calories_per_100g'] as num).toDouble(),
              proteinPer100g:
                  Value((row['protein_per_100g'] as num?)?.toDouble() ?? 0),
              carbsPer100g:
                  Value((row['carbs_per_100g'] as num?)?.toDouble() ?? 0),
              fatPer100g:
                  Value((row['fat_per_100g'] as num?)?.toDouble() ?? 0),
              fiberPer100g:
                  Value((row['fiber_per_100g'] as num?)?.toDouble()),
              sugarPer100g:
                  Value((row['sugar_per_100g'] as num?)?.toDouble()),
              sodiumPer100mg:
                  Value((row['sodium_per_100mg'] as num?)?.toDouble()),
              defaultServingG:
                  Value((row['default_serving_g'] as num?)?.toDouble() ?? 100),
              servingDescription: Value(row['serving_description'] as String?),
              isGlutenFree: Value(row['is_gluten_free'] as int? ?? 0),
              glutenStatus: Value(row['gluten_status'] as String? ?? 'unknown'),
              isCustom: Value(row['is_custom'] as int? ?? 0),
            ),
          );
        }
      });

      seedDb.dispose();
    } finally {
      await File(tempPath).delete();
    }
  }

  static Future<void> _seedExercises(AppDatabase db) async {
    final tempPath = await _assetToTempFile(_exercisesAsset);
    try {
      final seedDb = raw.sqlite3.open(tempPath);
      final result = seedDb.select('SELECT * FROM exercises');
      debugPrint('DbSeeder: loading ${result.length} exercises from asset');

      await db.batch((batch) {
        for (final row in result) {
          batch.insert(
            db.exercises,
            ExercisesCompanion.insert(
              name: row['name'] as String,
              category: row['category'] as String,
              metValue: (row['met_value'] as num).toDouble(),
              description: Value(row['description'] as String?),
            ),
          );
        }
      });

      seedDb.dispose();
    } finally {
      await File(tempPath).delete();
    }
  }
}
