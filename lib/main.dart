import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/seed/db_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbSeeder.seedIfNeeded();
  runApp(
    const ProviderScope(
      child: CalorieTrackerApp(),
    ),
  );
}
