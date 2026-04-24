import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';

part 'statistics_provider.g.dart';

// ── Period enum ───────────────────────────────────────────────────────────────

enum StatPeriod { d7, d14, d30 }

extension StatPeriodX on StatPeriod {
  int get days => this == StatPeriod.d7 ? 7 : this == StatPeriod.d14 ? 14 : 30;
  String get label =>
      this == StatPeriod.d7 ? '7D' : this == StatPeriod.d14 ? '14D' : '30D';
}

// ── Data classes ──────────────────────────────────────────────────────────────

@immutable
class DayStats {
  const DayStats({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.isLogged,
  });

  final String date; // yyyy-MM-dd
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final bool isLogged;
}

@immutable
class StatisticsState {
  const StatisticsState({
    required this.period,
    required this.dayStats,
    required this.currentStreak,
    required this.personalBest,
    required this.profile,
  });

  final StatPeriod period;

  /// Ordered oldest → newest; length == period.days.
  final List<DayStats> dayStats;

  final int currentStreak;
  final int personalBest;
  final UserProfileData? profile;

  // ── Derived helpers used by the UI ───────────────────────────────────────

  double get calorieTarget => (profile?.calorieTarget ?? 2000).toDouble();

  List<DayStats> get loggedDays => dayStats.where((d) => d.isLogged).toList();

  double get avgCalories {
    final logged = loggedDays;
    if (logged.isEmpty) return 0;
    return logged.fold(0.0, (s, d) => s + d.calories) / logged.length;
  }

  double get avgProtein {
    final logged = loggedDays;
    if (logged.isEmpty) return 0;
    return logged.fold(0.0, (s, d) => s + d.protein) / logged.length;
  }

  double get avgCarbs {
    final logged = loggedDays;
    if (logged.isEmpty) return 0;
    return logged.fold(0.0, (s, d) => s + d.carbs) / logged.length;
  }

  double get avgFat {
    final logged = loggedDays;
    if (logged.isEmpty) return 0;
    return logged.fold(0.0, (s, d) => s + d.fat) / logged.length;
  }

  /// Days where net kcal is within ±10% of target.
  int get daysOnTarget {
    final lo = calorieTarget * 0.90;
    final hi = calorieTarget * 1.10;
    return loggedDays.where((d) => d.calories >= lo && d.calories <= hi).length;
  }

  /// Percentage of logged days that are on target (0–100).
  double get onTargetPct {
    final y = loggedDays.length;
    if (y == 0) return 0;
    return daysOnTarget / y * 100;
  }

  /// For each day in [dayStats], return its dot status for the Days-on-Target
  /// indicator. Ordered same as [dayStats] (oldest→newest).
  List<DotStatus> get dotStatuses {
    final lo = calorieTarget * 0.90;
    final hi = calorieTarget * 1.10;
    return dayStats.map((d) {
      if (!d.isLogged) return DotStatus.noLog;
      return (d.calories >= lo && d.calories <= hi)
          ? DotStatus.hit
          : DotStatus.miss;
    }).toList();
  }
}

enum DotStatus { hit, miss, noLog }

// ── Providers ─────────────────────────────────────────────────────────────────

/// Period selector. Resets to [StatPeriod.d7] every time the screen opens
/// (default build() value), as per spec: "not persisted between sessions".
@riverpod
class StatisticsPeriod extends _$StatisticsPeriod {
  @override
  StatPeriod build() => StatPeriod.d7;

  void set(StatPeriod p) => state = p;
}

/// Main statistics computation. Re-runs whenever the period changes.
@riverpod
Future<StatisticsState> statisticsData(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final period = ref.watch(statisticsPeriodProvider);
  final days = period.days;

  // Build the list of date strings for the period: today-N+1 .. today.
  final today = DateTime.now();
  final periodDates = List.generate(
    days,
    (i) => _dateStr(today.subtract(Duration(days: days - 1 - i))),
  );

  // Fetch all data in parallel.
  final results = await Future.wait([
    db.foodLogsDao.getAllLoggedDates(),
    db.foodLogsDao.getLogsForDates(periodDates),
    db.userProfileDao.getProfile(),
  ]);

  final allDates = results[0] as List<String>;
  final periodLogs = results[1] as List<FoodLog>;
  final profile = results[2] as UserProfileData?;

  // Group logs by date.
  final logsByDate = <String, List<FoodLog>>{};
  for (final log in periodLogs) {
    logsByDate.putIfAbsent(log.date, () => []).add(log);
  }

  // Build per-day stats.
  final dayStats = periodDates.map((date) {
    final logs = logsByDate[date] ?? [];
    return DayStats(
      date: date,
      calories: logs.fold(0.0, (s, l) => s + l.calories),
      protein: logs.fold(0.0, (s, l) => s + l.protein),
      carbs: logs.fold(0.0, (s, l) => s + l.carbs),
      fat: logs.fold(0.0, (s, l) => s + l.fat),
      isLogged: logs.isNotEmpty,
    );
  }).toList();

  return StatisticsState(
    period: period,
    dayStats: dayStats,
    currentStreak: _calcStreak(allDates, today),
    personalBest: _calcBest(allDates),
    profile: profile,
  );
}

// ── Streak helpers ────────────────────────────────────────────────────────────

int _calcStreak(List<String> allDates, DateTime today) {
  if (allDates.isEmpty) return 0;
  final dateSet = allDates.toSet();
  final todayStr = _dateStr(today);
  final yestStr = _dateStr(today.subtract(const Duration(days: 1)));

  DateTime check;
  if (dateSet.contains(todayStr)) {
    check = today;
  } else if (dateSet.contains(yestStr)) {
    check = today.subtract(const Duration(days: 1));
  } else {
    return 0;
  }

  int streak = 0;
  while (dateSet.contains(_dateStr(check))) {
    streak++;
    check = check.subtract(const Duration(days: 1));
  }
  return streak;
}

int _calcBest(List<String> allDates) {
  if (allDates.isEmpty) return 0;
  final sorted = List<String>.from(allDates)..sort();
  int best = 1;
  int current = 1;
  for (int i = 1; i < sorted.length; i++) {
    final prev = DateTime.parse(sorted[i - 1]);
    final curr = DateTime.parse(sorted[i]);
    if (curr.difference(prev).inDays == 1) {
      current++;
      if (current > best) best = current;
    } else {
      current = 1;
    }
  }
  return best;
}

String _dateStr(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
