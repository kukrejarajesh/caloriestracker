import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'features/onboarding/onboarding_provider.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/statistics/statistics_screen.dart';
import 'features/weight/weight_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/food_log/food_search_screen.dart';
import 'features/exercise_log/exercise_search_screen.dart';

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
      onGenerateRoute: (settings) {
        if (settings.name == '/food-search') {
          // Arguments may be a plain String (meal type) for back-compat,
          // or a Map<String, String> with 'mealType' and optional 'date'.
          final args = settings.arguments;
          String mealType = 'breakfast';
          String? logDate;
          if (args is Map<String, String>) {
            mealType = args['mealType'] ?? 'breakfast';
            logDate = args['date'];
          } else if (args is String) {
            mealType = args;
          }
          return MaterialPageRoute(
            builder: (_) =>
                FoodSearchScreen(mealType: mealType, logDate: logDate),
            settings: settings,
          );
        }
        if (settings.name == '/exercise-search') {
          final args = settings.arguments;
          String? logDate;
          if (args is Map<String, String>) {
            logDate = args['date'];
          }
          return MaterialPageRoute(
            builder: (_) => ExerciseSearchScreen(logDate: logDate),
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
class _AppRouter extends ConsumerStatefulWidget {
  const _AppRouter();

  @override
  ConsumerState<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<_AppRouter> {
  bool _welcomeSeen = false;

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(onboardingCompleteProvider);

    return asyncValue.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (isComplete) {
        if (isComplete) return const _MainShell();
        if (!_welcomeSeen) {
          return WelcomeScreen(
            onGetStarted: () => setState(() => _welcomeSeen = true),
          );
        }
        return const OnboardingScreen();
      },
    );
  }
}

/// Main shell with bottom navigation: Dashboard · Statistics · Weight · Profile
class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    StatisticsScreen(),
    WeightScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight_outlined),
            activeIcon: Icon(Icons.monitor_weight),
            label: 'Weight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
