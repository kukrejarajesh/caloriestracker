import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/metadata_table.dart';

part 'metadata_dao.g.dart';

/// Simple key/value accessor for the [Metadata] table.
///
/// Used for infrastructure state like `seed_version`. Not for user data — put
/// that in user_profile_table.
@DriftAccessor(tables: [Metadata])
class MetadataDao extends DatabaseAccessor<AppDatabase>
    with _$MetadataDaoMixin {
  MetadataDao(super.db);

  Future<String?> getString(String key) async {
    final row = await (select(metadata)..where((m) => m.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<int?> getInt(String key) async {
    final v = await getString(key);
    return v == null ? null : int.tryParse(v);
  }

  Future<void> setString(String key, String value) async {
    await into(metadata).insertOnConflictUpdate(
      MetadataCompanion.insert(key: key, value: value),
    );
  }

  Future<void> setInt(String key, int value) =>
      setString(key, value.toString());
}
