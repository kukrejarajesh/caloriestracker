import 'package:drift/drift.dart';

/// Infrastructure-level key/value store for app metadata (seed version, feature
/// flags, etc). Separate from [UserProfile] — this holds *system* state, not
/// user-entered data.
///
/// Known keys:
///  - `seed_version`       : integer, which version of asset seed data is installed
///                           (see [DbSeeder.currentSeedVersion]).
///  - `last_seed_run_at`   : ISO-8601 timestamp (future — not written yet).
class Metadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
