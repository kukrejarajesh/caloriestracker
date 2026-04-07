import 'package:drift/drift.dart';

class WeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  RealColumn get weightKg => real()();
  TextColumn get loggedAt => text()();
}
