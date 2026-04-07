import 'package:drift/drift.dart';

class WaterLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  IntColumn get amountMl => integer()();
  TextColumn get loggedAt => text()();
}
