/// Exercise calorie burn calculator using MET values.
///
/// Formula: calories = MET × weightKg × durationHours
///
/// MET (Metabolic Equivalent of Task) values are stored per exercise in the
/// exercises table. A MET of 1.0 equals resting energy expenditure.
class MetCalculator {
  MetCalculator._();

  /// Calculates calories burned during exercise.
  ///
  /// [metValue]        — from the exercises table
  /// [weightKg]        — user's body weight
  /// [durationMinutes] — how long the exercise lasted
  static double caloriesBurned({
    required double metValue,
    required double weightKg,
    required int durationMinutes,
  }) {
    final hours = durationMinutes / 60.0;
    return metValue * weightKg * hours;
  }

  /// Rounds the result to 1 decimal place for display.
  static double caloriesBurnedRounded({
    required double metValue,
    required double weightKg,
    required int durationMinutes,
  }) {
    final raw = caloriesBurned(
      metValue: metValue,
      weightKg: weightKg,
      durationMinutes: durationMinutes,
    );
    return (raw * 10).round() / 10;
  }
}
