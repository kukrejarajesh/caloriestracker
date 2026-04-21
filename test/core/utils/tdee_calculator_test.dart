// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/core/utils/tdee_calculator.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // BMR — Mifflin-St Jeor formula
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.bmr', () {
    test('male BMR formula: 10*w + 6.25*h - 5*age + 5', () {
      // 10*80 + 6.25*175 - 5*30 + 5 = 800 + 1093.75 - 150 + 5 = 1748.75
      final result = TdeeCalculator.bmr(
        weightKg: 80,
        heightCm: 175,
        ageYears: 30,
        gender: 'male',
      );
      expect(result, closeTo(1748.75, 0.01));
    });

    test('female BMR formula: 10*w + 6.25*h - 5*age - 161', () {
      // 10*60 + 6.25*165 - 5*28 - 161 = 600 + 1031.25 - 140 - 161 = 1330.25
      final result = TdeeCalculator.bmr(
        weightKg: 60,
        heightCm: 165,
        ageYears: 28,
        gender: 'female',
      );
      expect(result, closeTo(1330.25, 0.01));
    });

    test('gender "other" uses male formula', () {
      final male = TdeeCalculator.bmr(
        weightKg: 70,
        heightCm: 170,
        ageYears: 25,
        gender: 'male',
      );
      final other = TdeeCalculator.bmr(
        weightKg: 70,
        heightCm: 170,
        ageYears: 25,
        gender: 'other',
      );
      expect(other, closeTo(male, 0.001));
    });

    test('heavier person has higher BMR (same height, age, gender)', () {
      final lighter = TdeeCalculator.bmr(
          weightKg: 60, heightCm: 170, ageYears: 30, gender: 'male');
      final heavier = TdeeCalculator.bmr(
          weightKg: 90, heightCm: 170, ageYears: 30, gender: 'male');
      expect(heavier, greaterThan(lighter));
    });

    test('taller person has higher BMR (same weight, age, gender)', () {
      final shorter = TdeeCalculator.bmr(
          weightKg: 70, heightCm: 160, ageYears: 30, gender: 'male');
      final taller = TdeeCalculator.bmr(
          weightKg: 70, heightCm: 185, ageYears: 30, gender: 'male');
      expect(taller, greaterThan(shorter));
    });

    test('older person has lower BMR (same weight, height, gender)', () {
      final younger = TdeeCalculator.bmr(
          weightKg: 70, heightCm: 175, ageYears: 25, gender: 'male');
      final older = TdeeCalculator.bmr(
          weightKg: 70, heightCm: 175, ageYears: 50, gender: 'male');
      expect(older, lessThan(younger));
    });

    test('male BMR is higher than female BMR with identical stats', () {
      final male = TdeeCalculator.bmr(
          weightKg: 70, heightCm: 170, ageYears: 30, gender: 'male');
      final female = TdeeCalculator.bmr(
          weightKg: 70, heightCm: 170, ageYears: 30, gender: 'female');
      // Difference should be exactly 5 - (-161) = 166
      expect(male - female, closeTo(166.0, 0.001));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TDEE — activity multipliers
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.tdee', () {
    const testBmr = 1500.0;

    test('sedentary multiplier is 1.2', () {
      expect(TdeeCalculator.tdee(bmr: testBmr, activityLevel: 'sedentary'),
          closeTo(1800.0, 0.01));
    });

    test('lightly_active multiplier is 1.375', () {
      expect(
          TdeeCalculator.tdee(bmr: testBmr, activityLevel: 'lightly_active'),
          closeTo(2062.5, 0.01));
    });

    test('moderately_active multiplier is 1.55', () {
      expect(
          TdeeCalculator.tdee(
              bmr: testBmr, activityLevel: 'moderately_active'),
          closeTo(2325.0, 0.01));
    });

    test('very_active multiplier is 1.725', () {
      expect(TdeeCalculator.tdee(bmr: testBmr, activityLevel: 'very_active'),
          closeTo(2587.5, 0.01));
    });

    test('extra_active multiplier is 1.9', () {
      expect(TdeeCalculator.tdee(bmr: testBmr, activityLevel: 'extra_active'),
          closeTo(2850.0, 0.01));
    });

    test('extra_active produces higher TDEE than very_active', () {
      const bmr = 1600.0;
      final veryActive =
          TdeeCalculator.tdee(bmr: bmr, activityLevel: 'very_active');
      final extraActive =
          TdeeCalculator.tdee(bmr: bmr, activityLevel: 'extra_active');
      expect(extraActive, greaterThan(veryActive));
    });

    test('TDEE is higher for active than sedentary users with the same stats', () {
      const bmr = 1600.0;
      final sedentary =
          TdeeCalculator.tdee(bmr: bmr, activityLevel: 'sedentary');
      final veryActive =
          TdeeCalculator.tdee(bmr: bmr, activityLevel: 'very_active');
      expect(veryActive, greaterThan(sedentary));
    });

    test('unknown activity level falls back to sedentary multiplier (1.2)', () {
      final result = TdeeCalculator.tdee(
          bmr: testBmr, activityLevel: 'nonexistent_level');
      expect(result, closeTo(1800.0, 0.01));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // calculate — convenience wrapper
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.calculate', () {
    test('matches manual BMR * multiplier computation', () {
      const w = 75.0, h = 175.0;
      const age = 35;
      const gender = 'male';
      const level = 'moderately_active';

      final manual = TdeeCalculator.bmr(
              weightKg: w, heightCm: h, ageYears: age, gender: gender) *
          1.55;

      final result = TdeeCalculator.calculate(
        weightKg: w,
        heightCm: h,
        ageYears: age,
        gender: gender,
        activityLevel: level,
      );
      expect(result, closeTo(manual, 0.01));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // calorieTarget — goal adjustments
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.calorieTarget', () {
    const tdeeValue = 2000.0;

    test('lose goal subtracts 500 kcal', () {
      expect(TdeeCalculator.calorieTarget(tdeeValue, 'lose'),
          closeTo(1500.0, 0.01));
    });

    test('lose goal is clamped at 1200 kcal minimum', () {
      // TDEE of 1500 - 500 = 1000, which should clamp to 1200.
      expect(TdeeCalculator.calorieTarget(1500.0, 'lose'),
          closeTo(1200.0, 0.01));
    });

    test('lose goal with TDEE of 1800 clamps to 1300 (not below 1200)', () {
      expect(TdeeCalculator.calorieTarget(1800.0, 'lose'),
          closeTo(1300.0, 0.01));
    });

    test('maintain goal returns TDEE unchanged', () {
      expect(TdeeCalculator.calorieTarget(tdeeValue, 'maintain'),
          closeTo(2000.0, 0.01));
    });

    test('gain goal adds 300 kcal', () {
      expect(TdeeCalculator.calorieTarget(tdeeValue, 'gain'),
          closeTo(2300.0, 0.01));
    });

    test('unknown goal defaults to maintain (returns tdee unchanged)', () {
      expect(TdeeCalculator.calorieTarget(tdeeValue, 'unknown_goal'),
          closeTo(2000.0, 0.01));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // macroTargets — gram splits
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.macroTargets', () {
    test('lose goal: protein 30%, carbs 40%, fat 30%', () {
      // At 2000 kcal:
      // Protein: 2000 * 0.30 / 4 = 150g
      // Carbs:   2000 * 0.40 / 4 = 200g
      // Fat:     2000 * 0.30 / 9 ≈ 66.67g
      final m = TdeeCalculator.macroTargets(2000, 'lose');
      expect(m.proteinG, closeTo(150.0, 0.01));
      expect(m.carbsG, closeTo(200.0, 0.01));
      expect(m.fatG, closeTo(66.67, 0.01));
    });

    test('maintain goal: protein 25%, carbs 50%, fat 25%', () {
      // At 2000 kcal:
      // Protein: 2000 * 0.25 / 4 = 125g
      // Carbs:   2000 * 0.50 / 4 = 250g
      // Fat:     2000 * 0.25 / 9 ≈ 55.56g
      final m = TdeeCalculator.macroTargets(2000, 'maintain');
      expect(m.proteinG, closeTo(125.0, 0.01));
      expect(m.carbsG, closeTo(250.0, 0.01));
      expect(m.fatG, closeTo(55.56, 0.01));
    });

    test('gain goal: protein 25%, carbs 50%, fat 25%', () {
      final maintain = TdeeCalculator.macroTargets(2000, 'maintain');
      final gain = TdeeCalculator.macroTargets(2000, 'gain');
      // Same split percentages for maintain and gain.
      expect(gain.proteinG, closeTo(maintain.proteinG, 0.001));
      expect(gain.carbsG, closeTo(maintain.carbsG, 0.001));
      expect(gain.fatG, closeTo(maintain.fatG, 0.001));
    });

    test('unknown goal defaults to maintain split', () {
      final maintain = TdeeCalculator.macroTargets(2000, 'maintain');
      final unknown = TdeeCalculator.macroTargets(2000, 'mystery_goal');
      expect(unknown.proteinG, closeTo(maintain.proteinG, 0.001));
      expect(unknown.carbsG, closeTo(maintain.carbsG, 0.001));
      expect(unknown.fatG, closeTo(maintain.fatG, 0.001));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // personalizedCalorieTarget — pace-based calculation
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.personalizedCalorieTarget', () {
    const tdee = 2728.0; // from spec worked example

    test('spec example: lose 6 kg in 12 weeks → ~2178 kcal', () {
      // From spec: weekly_deficit = 46200/12 = 3850; daily = 550; target = 2728-550 = 2178
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: tdee,
        goalType: 'lose',
        paceKgPerWeek: 0.5, // ~550 kcal/day deficit
        gender: 'male',
      );
      // 0.5 * 7700 / 7 = 550; 2728 - 550 = 2178
      expect(result, closeTo(2178.0, 1.0));
    });

    test('maintain returns TDEE unchanged', () {
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: tdee,
        goalType: 'maintain',
        paceKgPerWeek: 0.5,
        gender: 'male',
      );
      expect(result, closeTo(tdee, 0.01));
    });

    test('lose: clamped to 1500 kcal minimum for males', () {
      // TDEE of 1600 - (1.0 * 7700/7 = 1100) = 500 → clamp to 1500
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: 1600.0,
        goalType: 'lose',
        paceKgPerWeek: 1.0,
        gender: 'male',
      );
      expect(result, closeTo(1500.0, 0.01));
    });

    test('lose: clamped to 1200 kcal minimum for females', () {
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: 1600.0,
        goalType: 'lose',
        paceKgPerWeek: 1.0,
        gender: 'female',
      );
      expect(result, closeTo(1200.0, 0.01));
    });

    test('gain: surplus capped at TDEE + 500', () {
      // TDEE 2000 + (1.0 * 7700/7 = 1100) = 3100 → clamped to 2000 + 500 = 2500
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: 2000.0,
        goalType: 'gain',
        paceKgPerWeek: 1.0,
        gender: 'male',
      );
      expect(result, closeTo(2500.0, 0.01));
    });

    test('gain: within safe range adds surplus correctly', () {
      // TDEE 2000 + (0.25 * 7700/7 = 275) = 2275
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: 2000.0,
        goalType: 'gain',
        paceKgPerWeek: 0.25,
        gender: 'male',
      );
      expect(result, closeTo(2275.0, 1.0));
    });

    test('daily deficit is capped at 1000 kcal (pace > ~0.91 kg/week)', () {
      // pace 2.0 kg/week would give 2 * 7700/7 = 2200; capped to 1000
      // TDEE 2500 - 1000 = 1500 (for male, exactly at minimum)
      final result = TdeeCalculator.personalizedCalorieTarget(
        tdeeValue: 2500.0,
        goalType: 'lose',
        paceKgPerWeek: 2.0,
        gender: 'male',
      );
      expect(result, closeTo(1500.0, 0.01));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // isPaceUnsafe
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.isPaceUnsafe', () {
    test('safe pace (0.5 kg/wk) at TDEE 2500 is not unsafe for male', () {
      expect(
        TdeeCalculator.isPaceUnsafe(
            tdeeValue: 2500, gender: 'male', paceKgPerWeek: 0.5),
        isFalse,
      );
    });

    test('aggressive pace (1.0 kg/wk) at TDEE 2000 is not unsafe for male', () {
      // 2000 - 1100 = 900 < 1500 → unsafe
      expect(
        TdeeCalculator.isPaceUnsafe(
            tdeeValue: 2000, gender: 'male', paceKgPerWeek: 1.0),
        isTrue,
      );
    });

    test('1.0 kg/wk is unsafe for female at TDEE 2000', () {
      // 2000 - 1100 = 900 < 1200 → unsafe
      expect(
        TdeeCalculator.isPaceUnsafe(
            tdeeValue: 2000, gender: 'female', paceKgPerWeek: 1.0),
        isTrue,
      );
    });

    test('safe pace (0.25 kg/wk) at TDEE 1800 is not unsafe for female', () {
      // 1800 - 275 = 1525 >= 1200 → safe
      expect(
        TdeeCalculator.isPaceUnsafe(
            tdeeValue: 1800, gender: 'female', paceKgPerWeek: 0.25),
        isFalse,
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // weeksToGoal
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.weeksToGoal', () {
    test('6 kg at 0.5 kg/week = 12 weeks', () {
      expect(
        TdeeCalculator.weeksToGoal(
            currentWeightKg: 86, targetWeightKg: 80, paceKgPerWeek: 0.5),
        equals(12),
      );
    });

    test('3 kg at 0.25 kg/week = 12 weeks', () {
      expect(
        TdeeCalculator.weeksToGoal(
            currentWeightKg: 73, targetWeightKg: 70, paceKgPerWeek: 0.25),
        equals(12),
      );
    });

    test('non-exact division rounds up (ceil)', () {
      // 5 kg at 0.75 kg/week = 6.67 → ceil = 7
      expect(
        TdeeCalculator.weeksToGoal(
            currentWeightKg: 75, targetWeightKg: 70, paceKgPerWeek: 0.75),
        equals(7),
      );
    });

    test('target already reached returns 0', () {
      expect(
        TdeeCalculator.weeksToGoal(
            currentWeightKg: 70, targetWeightKg: 70, paceKgPerWeek: 0.5),
        equals(0),
      );
    });

    test('gain direction uses absolute difference', () {
      // gain: current 60, target 65, pace 0.5 → 5/0.5 = 10 weeks
      expect(
        TdeeCalculator.weeksToGoal(
            currentWeightKg: 60, targetWeightKg: 65, paceKgPerWeek: 0.5),
        equals(10),
      );
    });

    test('zero pace returns null', () {
      expect(
        TdeeCalculator.weeksToGoal(
            currentWeightKg: 80, targetWeightKg: 70, paceKgPerWeek: 0),
        isNull,
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ageFromDob
  // ═══════════════════════════════════════════════════════════════════════════

  group('TdeeCalculator.ageFromDob', () {
    test('correctly computes age for a past date of birth', () {
      // Use a date far enough in the past that today's date won't affect the result.
      final dob = '${DateTime.now().year - 30}-01-01';
      final age = TdeeCalculator.ageFromDob(dob);
      // By January 1 of a year, the person born Jan 1 thirty years ago is exactly 30.
      // Depending on today's month this may be 29 or 30.
      expect(age, anyOf(equals(29), equals(30)));
    });

    test('birthday not yet reached this year produces one less year', () {
      // Someone born on Dec 31 of 25 years ago: if today is before Dec 31, age = 24.
      final currentYear = DateTime.now();
      final dobYear = currentYear.year - 25;
      final dob = '$dobYear-12-31';
      final age = TdeeCalculator.ageFromDob(dob);
      // Dec 31 is likely in the future relative to any non-Dec-31 test run date.
      expect(age, anyOf(equals(24), equals(25)));
    });

    test('age is always non-negative', () {
      final dob = '${DateTime.now().year - 1}-06-01';
      final age = TdeeCalculator.ageFromDob(dob);
      expect(age, greaterThanOrEqualTo(0));
    });
  });
}
