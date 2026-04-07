import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies bundled asset databases to the app's writable storage on first launch.
///
/// Call once at startup, before opening the Drift DB, only when
/// [onboarding_complete] is 0 (handled by [AppDatabase] init logic).
class DbSeeder {
  DbSeeder._();

  static const _foodsAsset = 'assets/foods.db';
  static const _exercisesAsset = 'assets/exercises.db';

  static const _foodsFilename = 'foods_seed.db';
  static const _exercisesFilename = 'exercises_seed.db';

  /// Returns the writable path for the foods seed DB.
  static Future<String> foodsDbPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _foodsFilename);
  }

  /// Returns the writable path for the exercises seed DB.
  static Future<String> exercisesDbPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _exercisesFilename);
  }

  /// Copies both asset DBs to writable storage if they don't already exist.
  /// Safe to call on every launch — skips copy if file already present.
  static Future<void> seedIfNeeded() async {
    await _copyAssetIfAbsent(_foodsAsset, await foodsDbPath());
    await _copyAssetIfAbsent(_exercisesAsset, await exercisesDbPath());
  }

  static Future<void> _copyAssetIfAbsent(
      String assetPath, String destPath) async {
    final file = File(destPath);
    if (await file.exists()) return;

    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
  }
}
