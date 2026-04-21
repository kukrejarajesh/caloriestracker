/// TDEE calculator using the Mifflin-St Jeor formula.
///
/// BMR (male)   = 10 × weight(kg) + 6.25 × height(cm) − 5 × age + 5
/// BMR (female) = 10 × weight(kg) + 6.25 × height(cm) − 5 × age − 161
/// TDEE = BMR × activity multiplier
class TdeeCalculator {
  TdeeCalculator._();

  // ── Activity multipliers ─────────────────────────────────────────────────

  static const Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'lightly_active': 1.375,
    'moderately_active': 1.55,
    'very_active': 1.725,
    'extra_active': 1.9,
  };

  // ── Core calculations ────────────────────────────────────────────────────

  /// Calculates BMR using Mifflin-St Jeor.
  /// [gender] must be 'male' or 'female' (defaults to 'male' for 'other').
  static double bmr({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required String gender,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
    return gender == 'female' ? base - 161 : base + 5;
  }

  /// Calculates TDEE from BMR and activity level.
  static double tdee({
    required double bmr,
    required String activityLevel,
  }) {
    final multiplier = _activityMultipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  /// Convenience: calculates TDEE directly from profile values.
  static double calculate({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required String gender,
    required String activityLevel,
  }) {
    final b = TdeeCalculator.bmr(
      weightKg: weightKg,
      heightCm: heightCm,
      ageYears: ageYears,
      gender: gender,
    );
    return tdee(bmr: b, activityLevel: activityLevel);
  }

  // ── Calorie targets by goal ───────────────────────────────────────────────

  /// Adjusts TDEE based on goal type.
  /// lose: −500 kcal, maintain: ±0, gain: +300 kcal
  static double calorieTarget(double tdeeValue, String goalType) {
    switch (goalType) {
      case 'lose':
        return (tdeeValue - 500).clamp(1200, double.infinity);
      case 'gain':
        return tdeeValue + 300;
      case 'maintain':
      default:
        return tdeeValue;
    }
  }

  // ── Personalised calorie target ──────────────────────────────────────────

  /// Personalised daily calorie target driven by a weekly pace of change.
  ///
  /// Formula:
  ///   daily_change = paceKgPerWeek × 7700 / 7  (capped at 1000 kcal/day)
  ///   lose: target = TDEE − daily_change  → clamped to safety minimum
  ///   gain: target = TDEE + daily_change  → clamped to TDEE + 500 max
  ///   maintain: TDEE unchanged
  ///
  /// Safety minimums: 1500 kcal/day (male) / 1200 kcal/day (female).
  static double personalizedCalorieTarget({
    required double tdeeValue,
    required String goalType,
    required double paceKgPerWeek,
    required String gender,
  }) {
    if (goalType == 'maintain') return tdeeValue;
    final dailyChange = (paceKgPerWeek * 7700 / 7).clamp(0.0, 1000.0);
    final minKcal = gender == 'female' ? 1200.0 : 1500.0;
    if (goalType == 'lose') {
      return (tdeeValue - dailyChange).clamp(minKcal, double.infinity);
    } else {
      // gain
      return (tdeeValue + dailyChange).clamp(0.0, tdeeValue + 500);
    }
  }

  /// Returns true if [paceKgPerWeek] would push the daily target below the
  /// safe minimum for this gender/TDEE combination.
  static bool isPaceUnsafe({
    required double tdeeValue,
    required String gender,
    required double paceKgPerWeek,
  }) {
    final dailyChange = paceKgPerWeek * 7700 / 7;
    final minKcal = gender == 'female' ? 1200.0 : 1500.0;
    return (tdeeValue - dailyChange) < minKcal;
  }

  /// Estimated whole weeks to reach [targetWeightKg] from [currentWeightKg]
  /// at [paceKgPerWeek]. Returns null if pace is zero or inputs are invalid.
  static int? weeksToGoal({
    required double currentWeightKg,
    required double targetWeightKg,
    required double paceKgPerWeek,
  }) {
    if (paceKgPerWeek <= 0) return null;
    final diff = (currentWeightKg - targetWeightKg).abs();
    if (diff == 0) return 0;
    return (diff / paceKgPerWeek).ceil();
  }

  // ── Macro splits ──────────────────────────────────────────────────────────

  /// Returns macro targets in grams for a given calorie target and goal.
  ///
  /// Protein: 30 % lose / 25 % maintain / 25 % gain
  /// Carbs:   40 % lose / 50 % maintain / 50 % gain
  /// Fat:     30 % lose / 25 % maintain / 25 % gain
  static MacroTargets macroTargets(double calories, String goalType) {
    double proteinPct, carbsPct, fatPct;

    switch (goalType) {
      case 'lose':
        proteinPct = 0.30;
        carbsPct = 0.40;
        fatPct = 0.30;
        break;
      case 'gain':
        proteinPct = 0.25;
        carbsPct = 0.50;
        fatPct = 0.25;
        break;
      case 'maintain':
      default:
        proteinPct = 0.25;
        carbsPct = 0.50;
        fatPct = 0.25;
    }

    return MacroTargets(
      proteinG: (calories * proteinPct) / 4,
      carbsG: (calories * carbsPct) / 4,
      fatG: (calories * fatPct) / 9,
    );
  }

  /// Calculates age in years from a date-of-birth string (yyyy-MM-dd).
  static int ageFromDob(String dob) {
    final birth = DateTime.parse(dob);
    final today = DateTime.now();
    int age = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      age--;
    }
    return age;
  }
}

class MacroTargets {
  final double proteinG;
  final double carbsG;
  final double fatG;

  const MacroTargets({
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}
