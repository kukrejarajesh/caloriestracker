// ignore_for_file: lines_longer_than_80_chars

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/data/database/app_database.dart';

/// Returns a fully-populated companion for quick inserts.
UserProfileCompanion _buildProfile({
  int id = 1,
  String name = 'Test User',
  String dob = '1990-05-15',
  String gender = 'female',
  double heightCm = 165.0,
  double weightKg = 60.0,
  String activityLevel = 'moderately_active',
  String goalType = 'maintain',
  int isGlutenFree = 1,
  int onboardingComplete = 1,
}) {
  return UserProfileCompanion.insert(
    id: Value(id),
    name: Value(name),
    dateOfBirth: Value(dob),
    gender: Value(gender),
    heightCm: Value(heightCm),
    weightKg: Value(weightKg),
    activityLevel: Value(activityLevel),
    goalType: Value(goalType),
    isGlutenFree: Value(isGlutenFree),
    onboardingComplete: Value(onboardingComplete),
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(),
      skipSeeding: true,
    );
  });

  tearDown(() async {
    await db.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Gluten safety — is_gluten_free defaults
  // ═══════════════════════════════════════════════════════════════════════════

  group('gluten safety — user profile', () {
    test('is_gluten_free defaults to 1 when profile is inserted without explicit value', () async {
      // Insert with the minimum required fields, relying on column defaults.
      await db.userProfileDao.upsertProfile(
        const UserProfileCompanion(id: Value(1)),
      );
      final profile = await db.userProfileDao.getProfile();
      expect(
        profile!.isGlutenFree,
        equals(1),
        reason: 'Gluten-free mode must be on by default to protect the user',
      );
    });

    test('is_gluten_free value 1 survives an upsert round-trip', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(isGlutenFree: 1));
      final profile = await db.userProfileDao.getProfile();
      expect(profile!.isGlutenFree, equals(1));
    });

    test('is_gluten_free can be explicitly set to 0 (user override)', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(isGlutenFree: 0));
      final profile = await db.userProfileDao.getProfile();
      // This is a deliberate user override — we verify the value is stored correctly.
      expect(profile!.isGlutenFree, equals(0));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // getProfile / watchProfile
  // ═══════════════════════════════════════════════════════════════════════════

  group('getProfile', () {
    test('returns null when no profile exists', () async {
      final profile = await db.userProfileDao.getProfile();
      expect(profile, isNull);
    });

    test('returns the profile after upsert', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(name: 'Jane Doe'));
      final profile = await db.userProfileDao.getProfile();
      expect(profile, isNotNull);
      expect(profile!.name, equals('Jane Doe'));
    });

    test('stores all fields correctly', () async {
      await db.userProfileDao.upsertProfile(
        _buildProfile(
          gender: 'male',
          heightCm: 180.0,
          weightKg: 85.0,
          activityLevel: 'very_active',
          goalType: 'lose',
        ),
      );
      final profile = await db.userProfileDao.getProfile();
      expect(profile!.gender, equals('male'));
      expect(profile.heightCm, closeTo(180.0, 0.001));
      expect(profile.weightKg, closeTo(85.0, 0.001));
      expect(profile.activityLevel, equals('very_active'));
      expect(profile.goalType, equals('lose'));
    });
  });

  group('watchProfile', () {
    test('stream emits null before any profile exists', () async {
      final value = await db.userProfileDao.watchProfile().first;
      expect(value, isNull);
    });

    test('stream emits profile after upsert', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(name: 'Stream User'));
      final value = await db.userProfileDao.watchProfile().first;
      expect(value, isNotNull);
      expect(value!.name, equals('Stream User'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // upsertProfile (insert-or-replace)
  // ═══════════════════════════════════════════════════════════════════════════

  group('upsertProfile', () {
    test('subsequent upsert overwrites the previous profile', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(name: 'First Name', weightKg: 70));
      await db.userProfileDao.upsertProfile(_buildProfile(name: 'Updated Name', weightKg: 68));

      final profile = await db.userProfileDao.getProfile();
      expect(profile!.name, equals('Updated Name'));
      expect(profile.weightKg, closeTo(68, 0.001));
    });

    test('upsert with only id preserves table defaults for numeric columns', () async {
      await db.userProfileDao.upsertProfile(
        const UserProfileCompanion(id: Value(1)),
      );
      final profile = await db.userProfileDao.getProfile();
      // waterTargetMl has a table default of 2000.
      expect(profile!.waterTargetMl, equals(2000));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // isOnboardingComplete
  // ═══════════════════════════════════════════════════════════════════════════

  group('isOnboardingComplete', () {
    test('returns false when no profile exists', () async {
      final result = await db.userProfileDao.isOnboardingComplete();
      expect(result, isFalse);
    });

    test('returns false when onboarding_complete is 0', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(onboardingComplete: 0));
      final result = await db.userProfileDao.isOnboardingComplete();
      expect(result, isFalse);
    });

    test('returns true when onboarding_complete is 1', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(onboardingComplete: 1));
      final result = await db.userProfileDao.isOnboardingComplete();
      expect(result, isTrue);
    });

    test('transitions from false to true after completing onboarding', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(onboardingComplete: 0));
      expect(await db.userProfileDao.isOnboardingComplete(), isFalse);

      await db.userProfileDao.upsertProfile(_buildProfile(onboardingComplete: 1));
      expect(await db.userProfileDao.isOnboardingComplete(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // updateProfile
  // ═══════════════════════════════════════════════════════════════════════════

  group('updateProfile', () {
    test('update returns true and changes the target field', () async {
      await db.userProfileDao.upsertProfile(_buildProfile(weightKg: 75.0));

      final profile = await db.userProfileDao.getProfile();
      final updated = UserProfileCompanion(
        id: Value(profile!.id),
        name: Value(profile.name),
        dateOfBirth: Value(profile.dateOfBirth),
        gender: Value(profile.gender),
        heightCm: Value(profile.heightCm),
        weightKg: const Value(72.0),
        activityLevel: Value(profile.activityLevel),
        goalType: Value(profile.goalType),
        isGlutenFree: Value(profile.isGlutenFree),
        onboardingComplete: Value(profile.onboardingComplete),
      );

      final success = await db.userProfileDao.updateProfile(updated);
      expect(success, isTrue);

      final after = await db.userProfileDao.getProfile();
      expect(after!.weightKg, closeTo(72.0, 0.001));
    });
  });
}
