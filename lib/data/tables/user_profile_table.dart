import 'package:drift/drift.dart';

class UserProfile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text().nullable()();
  TextColumn get dateOfBirth => text().nullable()();
  TextColumn get gender => text()
      .nullable()
      .customConstraint(
          "CHECK(gender IN ('male','female','other'))")();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get activityLevel => text()
      .nullable()
      .customConstraint(
          "CHECK(activity_level IN ('sedentary','lightly_active','moderately_active','very_active'))")();
  TextColumn get goalType => text()
      .nullable()
      .customConstraint(
          "CHECK(goal_type IN ('lose','maintain','gain'))")();
  RealColumn get calorieTarget => real().nullable()();
  RealColumn get proteinTargetG => real().nullable()();
  RealColumn get carbsTargetG => real().nullable()();
  RealColumn get fatTargetG => real().nullable()();
  RealColumn get targetWeightKg => real().nullable()();
  RealColumn get paceKgPerWeek  => real().withDefault(const Constant(0.5))();
  IntColumn get waterTargetMl => integer().withDefault(const Constant(2000))();
  IntColumn get isGlutenFree => integer().withDefault(const Constant(1))();
  IntColumn get dbVersion => integer().withDefault(const Constant(1))();
  IntColumn get onboardingComplete => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
