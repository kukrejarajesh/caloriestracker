import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/tdee_calculator.dart';
import '../../data/database/app_database.dart';

part 'profile_provider.g.dart';

@riverpod
Stream<UserProfileData?> userProfile(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.userProfileDao.watchProfile();
}

class ProfileEditState {
  final String name;
  final String? dateOfBirth;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final String? goalType;
  final double? targetWeightKg;
  final double paceKgPerWeek;
  final int waterTargetMl;
  final bool isGlutenFree;
  final bool isSaving;
  final String? error;
  final bool success;

  const ProfileEditState({
    this.name = '',
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.goalType,
    this.targetWeightKg,
    this.paceKgPerWeek = 0.5,
    this.waterTargetMl = 2000,
    this.isGlutenFree = true,
    this.isSaving = false,
    this.error,
    this.success = false,
  });

  static const _sentinel = Object();

  ProfileEditState copyWith({
    String? name,
    String? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goalType,
    Object? targetWeightKg = _sentinel,
    double? paceKgPerWeek,
    int? waterTargetMl,
    bool? isGlutenFree,
    bool? isSaving,
    String? error,
    bool? success,
  }) =>
      ProfileEditState(
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        heightCm: heightCm ?? this.heightCm,
        weightKg: weightKg ?? this.weightKg,
        activityLevel: activityLevel ?? this.activityLevel,
        goalType: goalType ?? this.goalType,
        targetWeightKg: targetWeightKg == _sentinel
            ? this.targetWeightKg
            : targetWeightKg as double?,
        paceKgPerWeek: paceKgPerWeek ?? this.paceKgPerWeek,
        waterTargetMl: waterTargetMl ?? this.waterTargetMl,
        isGlutenFree: isGlutenFree ?? this.isGlutenFree,
        isSaving: isSaving ?? this.isSaving,
        error: error,
        success: success ?? this.success,
      );

  static ProfileEditState fromProfile(UserProfileData p) => ProfileEditState(
        name: p.name ?? '',
        dateOfBirth: p.dateOfBirth,
        gender: p.gender,
        heightCm: p.heightCm,
        weightKg: p.weightKg,
        activityLevel: p.activityLevel,
        goalType: p.goalType,
        targetWeightKg: p.targetWeightKg,
        paceKgPerWeek: p.paceKgPerWeek,
        waterTargetMl: p.waterTargetMl,
        isGlutenFree: p.isGlutenFree == 1,
      );
}

@riverpod
class ProfileEditNotifier extends _$ProfileEditNotifier {
  @override
  ProfileEditState build() => const ProfileEditState();

  void loadFrom(UserProfileData profile) =>
      state = ProfileEditState.fromProfile(profile);

  void setName(String v) => state = state.copyWith(name: v);
  void setDateOfBirth(String v) => state = state.copyWith(dateOfBirth: v);
  void setGender(String v) => state = state.copyWith(gender: v);
  void setHeightCm(double v) => state = state.copyWith(heightCm: v);
  void setWeightKg(double v) => state = state.copyWith(weightKg: v);
  void setActivityLevel(String v) => state = state.copyWith(activityLevel: v);
  void setGoalType(String v) => state = state.copyWith(goalType: v);
  void setTargetWeightKg(double? v) =>
      state = state.copyWith(targetWeightKg: v);
  void setPaceKgPerWeek(double v) => state = state.copyWith(paceKgPerWeek: v);
  void setWaterTarget(int v) => state = state.copyWith(waterTargetMl: v);
  void setIsGlutenFree(bool v) => state = state.copyWith(isGlutenFree: v);

  /// Live preview of the calculated calorie target given current state.
  /// Returns null if required fields are missing.
  double? get previewCalorieTarget {
    final s = state;
    if (s.weightKg == null ||
        s.heightCm == null ||
        s.dateOfBirth == null ||
        s.gender == null ||
        s.activityLevel == null ||
        s.goalType == null) {
      return null;
    }
    final age = TdeeCalculator.ageFromDob(s.dateOfBirth!);
    final b = TdeeCalculator.bmr(
      weightKg: s.weightKg!,
      heightCm: s.heightCm!,
      ageYears: age,
      gender: s.gender!,
    );
    final t = TdeeCalculator.tdee(bmr: b, activityLevel: s.activityLevel!);
    if (s.goalType == 'maintain') return t;
    return (s.targetWeightKg != null)
        ? TdeeCalculator.personalizedCalorieTarget(
            tdeeValue: t,
            goalType: s.goalType!,
            paceKgPerWeek: s.paceKgPerWeek,
            gender: s.gender!,
          )
        : TdeeCalculator.calorieTarget(t, s.goalType!);
  }

  Future<bool> save() async {
    final s = state;
    if (s.name.trim().isEmpty ||
        s.dateOfBirth == null ||
        s.gender == null ||
        s.heightCm == null ||
        s.weightKg == null ||
        s.activityLevel == null ||
        s.goalType == null) {
      state = state.copyWith(error: 'Please fill in all fields.');
      return false;
    }

    state = state.copyWith(isSaving: true, error: null, success: false);
    try {
      final db = ref.read(appDatabaseProvider);
      final age = TdeeCalculator.ageFromDob(s.dateOfBirth!);
      final bmr = TdeeCalculator.bmr(
        weightKg: s.weightKg!,
        heightCm: s.heightCm!,
        ageYears: age,
        gender: s.gender!,
      );
      final tdeeVal =
          TdeeCalculator.tdee(bmr: bmr, activityLevel: s.activityLevel!);

      final calorieTarget =
          (s.targetWeightKg != null && s.goalType != 'maintain')
              ? TdeeCalculator.personalizedCalorieTarget(
                  tdeeValue: tdeeVal,
                  goalType: s.goalType!,
                  paceKgPerWeek: s.paceKgPerWeek,
                  gender: s.gender!,
                )
              : TdeeCalculator.calorieTarget(tdeeVal, s.goalType!);

      final macros = TdeeCalculator.macroTargets(calorieTarget, s.goalType!);

      await db.userProfileDao.upsertProfile(
        UserProfileCompanion(
          id: const Value(1),
          name: Value(s.name.trim()),
          dateOfBirth: Value(s.dateOfBirth),
          gender: Value(s.gender),
          heightCm: Value(s.heightCm),
          weightKg: Value(s.weightKg),
          activityLevel: Value(s.activityLevel),
          goalType: Value(s.goalType),
          calorieTarget: Value(calorieTarget),
          proteinTargetG: Value(macros.proteinG),
          carbsTargetG: Value(macros.carbsG),
          fatTargetG: Value(macros.fatG),
          targetWeightKg: Value(s.targetWeightKg),
          paceKgPerWeek: Value(s.paceKgPerWeek),
          waterTargetMl: Value(s.waterTargetMl),
          isGlutenFree: Value(s.isGlutenFree ? 1 : 0),
          onboardingComplete: const Value(1),
        ),
      );

      state = state.copyWith(isSaving: false, success: true);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}
