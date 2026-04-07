import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/exercise_logs_table.dart';
import '../tables/exercises_table.dart';

part 'exercise_logs_dao.g.dart';

@DriftAccessor(tables: [Exercises, ExerciseLogs])
class ExerciseLogsDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseLogsDaoMixin {
  ExerciseLogsDao(super.db);

  Future<List<Exercise>> searchExercises(String query) =>
      (select(exercises)..where((e) => e.name.like('%$query%'))).get();

  Stream<List<Exercise>> watchAllExercises() => select(exercises).watch();

  Stream<List<ExerciseLog>> watchLogsForDate(String date) =>
      (select(exerciseLogs)..where((l) => l.date.equals(date))).watch();

  Future<List<ExerciseLog>> getLogsForDate(String date) =>
      (select(exerciseLogs)..where((l) => l.date.equals(date))).get();

  Future<int> insertLog(ExerciseLogsCompanion entry) =>
      into(exerciseLogs).insert(entry);

  Future<int> deleteLog(int id) =>
      (delete(exerciseLogs)..where((l) => l.id.equals(id))).go();
}
