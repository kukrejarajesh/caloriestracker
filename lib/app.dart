import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('Calorie Tracker'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
