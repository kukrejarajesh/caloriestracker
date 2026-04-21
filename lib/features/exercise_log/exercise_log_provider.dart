import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/met_calculator.dart';
import '../../data/database/app_database.dart';

part 'exercise_log_provider.g.dart';

// ── Exercise search ───────────────────────────────────────────────────────────

@riverpod
class ExerciseSearchQuery extends _$ExerciseSearchQuery {
  @override
  String build() => '';
  void set(String v) => state = v;
}

@riverpod
Future<List<Exercise>> exerciseSearch(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = ref.watch(exerciseSearchQueryProvider);
  return db.exerciseLogsDao.searchExercises(query);
}

// ── Log state ─────────────────────────────────────────────────────────────────

class ExerciseLogState {
  final bool isLogging;
  final String? error;
  final bool success;

  const ExerciseLogState({
    this.isLogging = false,
    this.error,
    this.success = false,
  });

  ExerciseLogState copyWith({bool? isLogging, String? error, bool? success}) =>
      ExerciseLogState(
        isLogging: isLogging ?? this.isLogging,
        error: error,
        success: success ?? this.success,
      );
}

@riverpod
class ExerciseLogNotifier extends _$ExerciseLogNotifier {
  @override
  ExerciseLogState build() => const ExerciseLogState();

  Future<bool> logExercise({
    required Exercise exercise,
    required int durationMinutes,
    required String date,
  }) async {
    state = state.copyWith(isLogging: true, error: null, success: false);
    try {
      final db = ref.read(appDatabaseProvider);
      final profile = await db.userProfileDao.getProfile();
      final weightKg = profile?.weightKg ?? 70.0;

      final burned = MetCalculator.caloriesBurnedRounded(
        metValue: exercise.metValue,
        weightKg: weightKg,
        durationMinutes: durationMinutes,
      );

      await db.exerciseLogsDao.insertLog(
        ExerciseLogsCompanion(
          date: Value(date),
          exerciseId: Value(exercise.id),
          exerciseName: Value(exercise.name),
          durationMinutes: Value(durationMinutes),
          caloriesBurned: Value(burned),
          loggedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

      state = state.copyWith(isLogging: false, success: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLogging: false, error: e.toString());
      return false;
    }
  }
}
