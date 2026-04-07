import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_provider.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/food_log/food_search_screen.dart';

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: {
        '/dashboard': (_) => const DashboardScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/food-search') {
          final mealType = (settings.arguments as String?) ?? 'breakfast';
          return MaterialPageRoute(
            builder: (_) => FoodSearchScreen(mealType: mealType),
            settings: settings,
          );
        }
        return null;
      },
      home: const _AppRouter(),
    );
  }
}

/// Checks onboarding status and routes to the correct screen.
class _AppRouter extends ConsumerWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(onboardingCompleteProvider);

    return asyncValue.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (isComplete) {
        if (isComplete) {
          return const DashboardScreen();
        }
        return const OnboardingScreen();
      },
    );
  }
}
