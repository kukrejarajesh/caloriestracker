import 'package:drift/drift.dart';
import 'foods_table.dart';

class FoodLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get mealType => text().customConstraint(
      "NOT NULL CHECK(meal_type IN ('breakfast','lunch','dinner','snacks'))")();
  IntColumn get foodId => integer().references(Foods, #id)();
  RealColumn get quantityG => real()();
  RealColumn get calories => real()();
  RealColumn get protein => real().withDefault(const Constant(0))();
  RealColumn get carbs => real().withDefault(const Constant(0))();
  RealColumn get fat => real().withDefault(const Constant(0))();
  TextColumn get glutenStatus => text().withDefault(const Constant('unknown'))();
  TextColumn get loggedAt => text()();
}
