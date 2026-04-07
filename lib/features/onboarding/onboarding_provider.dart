import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';
import '../../core/utils/tdee_calculator.dart';

part 'onboarding_provider.g.dart';

// ── Form state ────────────────────────────────────────────────────────────────

class OnboardingFormState {
  final String name;
  final String? dateOfBirth;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final String? goalType;
  final bool isGlutenFree;
  final bool isSaving;
  final String? error;

  const OnboardingFormState({
    this.name = '',
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.goalType,
    this.isGlutenFree = true,
    this.isSaving = false,
    this.error,
  });

  OnboardingFormState copyWith({
    String? name,
    String? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goalType,
    bool? isGlutenFree,
    bool? isSaving,
    String? error,
  }) {
    return OnboardingFormState(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goalType: goalType ?? this.goalType,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingFormState build() => const OnboardingFormState();

  void setName(String v) => state = state.copyWith(name: v);
  void setDateOfBirth(String v) => state = state.copyWith(dateOfBirth: v);
  void setGender(String v) => state = state.copyWith(gender: v);
  void setHeightCm(double v) => state = state.copyWith(heightCm: v);
  void setWeightKg(double v) => state = state.copyWith(weightKg: v);
  void setActivityLevel(String v) => state = state.copyWith(activityLevel: v);
  void setGoalType(String v) => state = state.copyWith(goalType: v);
  void setIsGlutenFree(bool v) => state = state.copyWith(isGlutenFree: v);

  /// Validates that all required fields are present before saving.
  bool get isComplete =>
      state.name.trim().isNotEmpty &&
      state.dateOfBirth != null &&
      state.gender != null &&
      state.heightCm != null &&
      state.weightKg != null &&
      state.activityLevel != null &&
      state.goalType != null;

  /// Calculates TDEE + macros, saves profile to DB, sets onboarding_complete.
  Future<bool> saveProfile() async {
    if (!isComplete) {
      state = state.copyWith(error: 'Please fill in all fields.');
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final db = ref.read(appDatabaseProvider);
      final s = state;

      final age = TdeeCalculator.ageFromDob(s.dateOfBirth!);
      final bmr = TdeeCalculator.bmr(
        weightKg: s.weightKg!,
        heightCm: s.heightCm!,
        ageYears: age,
        gender: s.gender!,
      );
      final tdeeVal = TdeeCalculator.tdee(
        bmr: bmr,
        activityLevel: s.activityLevel!,
      );
      final calorieTarget =
          TdeeCalculator.calorieTarget(tdeeVal, s.goalType!);
      final macros =
          TdeeCalculator.macroTargets(calorieTarget, s.goalType!);

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
          isGlutenFree: Value(s.isGlutenFree ? 1 : 0),
          onboardingComplete: const Value(1),
        ),
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

// ── Onboarding complete check ─────────────────────────────────────────────────

@riverpod
Future<bool> onboardingComplete(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.userProfileDao.isOnboardingComplete();
}
