import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/user_profile_table.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfile])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  /// Watch the single user profile row (id = 1).
  Stream<UserProfileData?> watchProfile() =>
      (select(userProfile)..where((p) => p.id.equals(1)))
          .watchSingleOrNull();

  Future<UserProfileData?> getProfile() =>
      (select(userProfile)..where((p) => p.id.equals(1))).getSingleOrNull();

  /// Insert or replace the profile row.
  Future<int> upsertProfile(UserProfileCompanion entry) =>
      into(userProfile).insertOnConflictUpdate(entry);

  Future<bool> updateProfile(UserProfileCompanion entry) =>
      update(userProfile).replace(entry);

  Future<bool> isOnboardingComplete() async {
    final profile = await getProfile();
    return (profile?.onboardingComplete ?? 0) == 1;
  }
}
