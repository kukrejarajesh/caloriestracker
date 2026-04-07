import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/foods_table.dart';

part 'foods_dao.g.dart';

@DriftAccessor(tables: [Foods])
class FoodsDao extends DatabaseAccessor<AppDatabase> with _$FoodsDaoMixin {
  FoodsDao(super.db);

  /// Search foods by name. When [glutenFreeOnly] is true (default), only
  /// returns foods with gluten_status = 'gluten_free'.
  Future<List<Food>> searchFoods(String query,
      {bool glutenFreeOnly = true}) {
    final q = select(foods)
      ..where((f) => f.name.like('%$query%'));
    if (glutenFreeOnly) {
      q.where((f) => f.glutenStatus.equals('gluten_free'));
    }
    return q.get();
  }

  /// All foods stream — gluten-free filter applied by default.
  Stream<List<Food>> watchFoods({bool glutenFreeOnly = true}) {
    final q = select(foods);
    if (glutenFreeOnly) {
      q.where((f) => f.glutenStatus.equals('gluten_free'));
    }
    return q.watch();
  }

  Future<Food?> getFoodById(int id) =>
      (select(foods)..where((f) => f.id.equals(id))).getSingleOrNull();

  Future<int> insertCustomFood(FoodsCompanion entry) =>
      into(foods).insert(entry);
}
