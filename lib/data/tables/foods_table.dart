import 'package:drift/drift.dart';

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get category => text()();
  RealColumn get caloriesPer100g => real()();
  RealColumn get proteinPer100g => real().withDefault(const Constant(0))();
  RealColumn get carbsPer100g => real().withDefault(const Constant(0))();
  RealColumn get fatPer100g => real().withDefault(const Constant(0))();
  RealColumn get fiberPer100g => real().nullable()();
  RealColumn get sugarPer100g => real().nullable()();
  RealColumn get sodiumPer100mg => real().nullable()();
  RealColumn get defaultServingG => real().withDefault(const Constant(100))();
  TextColumn get servingDescription => text().nullable()();
  IntColumn get isGlutenFree => integer().withDefault(const Constant(0))();
  TextColumn get glutenStatus => text()
      .withDefault(const Constant('unknown'))
      .customConstraint(
          "NOT NULL DEFAULT 'unknown' CHECK(gluten_status IN ('gluten_free','contains_gluten','may_contain','unknown'))")();
  IntColumn get isCustom => integer().withDefault(const Constant(0))();
}
