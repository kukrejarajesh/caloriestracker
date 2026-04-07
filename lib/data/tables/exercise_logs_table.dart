import 'package:drift/drift.dart';
import 'exercises_table.dart';

class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get durationMinutes => integer()();
  RealColumn get caloriesBurned => real()();
  TextColumn get loggedAt => text()();
}
