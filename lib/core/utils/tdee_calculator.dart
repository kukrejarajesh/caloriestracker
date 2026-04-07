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
