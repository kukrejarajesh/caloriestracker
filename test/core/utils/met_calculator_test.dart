// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/core/utils/met_calculator.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // caloriesBurned — core formula
  // ═══════════════════════════════════════════════════════════════════════════

  group('MetCalculator.caloriesBurned', () {
    test('formula: MET * weightKg * (durationMinutes / 60)', () {
      // 8.0 MET (running) * 70 kg * (60 min / 60) = 560 kcal
      final result = MetCalculator.caloriesBurned(
        metValue: 8.0,
        weightKg: 70,
        durationMinutes: 60,
      );
      expect(result, closeTo(560.0, 0.001));
    });

    test('30-minute walk at MET 3.5 with 80 kg body weight', () {
      // 3.5 * 80 * (30/60) = 3.5 * 80 * 0.5 = 140 kcal
      final result = MetCalculator.caloriesBurned(
        metValue: 3.5,
        weightKg: 80,
        durationMinutes: 30,
      );
      expect(result, closeTo(140.0, 0.001));
    });

    test('heavier person burns more calories for the same exercise', () {
      final lighter = MetCalculator.caloriesBurned(
          metValue: 6.0, weightKg: 60, durationMinutes: 45);
      final heavier = MetCalculator.caloriesBurned(
          metValue: 6.0, weightKg: 90, durationMinutes: 45);
      expect(heavier, greaterThan(lighter));
    });

    test('longer duration burns more calories', () {
      final shorter = MetCalculator.caloriesBurned(
          metValue: 5.0, weightKg: 70, durationMinutes: 20);
      final longer = MetCalculator.caloriesBurned(
          metValue: 5.0, weightKg: 70, durationMinutes: 60);
      expect(longer, greaterThan(shorter));
    });

    test('higher MET value burns more calories', () {
      final lowMet = MetCalculator.caloriesBurned(
          metValue: 3.0, weightKg: 70, durationMinutes: 30);
      final highMet = MetCalculator.caloriesBurned(
          metValue: 10.0, weightKg: 70, durationMinutes: 30);
      expect(highMet, greaterThan(lowMet));
    });

    test('zero duration produces zero calories', () {
      final result = MetCalculator.caloriesBurned(
        metValue: 8.0,
        weightKg: 70,
        durationMinutes: 0,
      );
      expect(result, closeTo(0.0, 0.001));
    });

    test('result is proportional to weight — doubling weight doubles calories', () {
      final single = MetCalculator.caloriesBurned(
          metValue: 5.0, weightKg: 60, durationMinutes: 30);
      final doubled = MetCalculator.caloriesBurned(
          metValue: 5.0, weightKg: 120, durationMinutes: 30);
      expect(doubled, closeTo(single * 2, 0.001));
    });

    test('result is proportional to duration — doubling duration doubles calories', () {
      final single = MetCalculator.caloriesBurned(
          metValue: 5.0, weightKg: 70, durationMinutes: 30);
      final doubled = MetCalculator.caloriesBurned(
          metValue: 5.0, weightKg: 70, durationMinutes: 60);
      expect(doubled, closeTo(single * 2, 0.001));
    });

    test('MET of 1.0 represents resting burn rate', () {
      // 1.0 * 70 * (60/60) = 70 kcal/hour at rest
      final resting = MetCalculator.caloriesBurned(
        metValue: 1.0,
        weightKg: 70,
        durationMinutes: 60,
      );
      expect(resting, closeTo(70.0, 0.001));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // caloriesBurnedRounded — rounding behaviour
  // ═══════════════════════════════════════════════════════════════════════════

  group('MetCalculator.caloriesBurnedRounded', () {
    test('result is rounded to 1 decimal place', () {
      // 7.0 * 75 * (45/60) = 7.0 * 75 * 0.75 = 393.75 → rounds to 393.8
      final result = MetCalculator.caloriesBurnedRounded(
        metValue: 7.0,
        weightKg: 75,
        durationMinutes: 45,
      );
      expect(result, closeTo(393.8, 0.05));
    });

    test('rounded result has at most one significant decimal digit', () {
      final result = MetCalculator.caloriesBurnedRounded(
        metValue: 5.5,
        weightKg: 68,
        durationMinutes: 40,
      );
      // 5.5 * 68 * (40/60) ≈ 249.333... → rounds to 249.3
      expect(result, closeTo(249.3, 0.05));
      // Verify it's rounded to 1dp by checking the string representation.
      final str = result.toString();
      if (str.contains('.')) {
        expect(str.split('.').last.length, lessThanOrEqualTo(1));
      }
    });

    test('rounded value matches manual rounding of raw formula', () {
      const met = 6.0, kg = 80.0;
      const mins = 35;
      final raw = met * kg * (mins / 60.0);
      final expected = (raw * 10).round() / 10;

      final result = MetCalculator.caloriesBurnedRounded(
        metValue: met,
        weightKg: kg,
        durationMinutes: mins,
      );
      expect(result, closeTo(expected, 0.0001));
    });

    test('rounded result for exact values produces whole number with .0 decimal', () {
      // 8.0 * 75 * (60/60) = 600.0 exactly
      final result = MetCalculator.caloriesBurnedRounded(
        metValue: 8.0,
        weightKg: 75,
        durationMinutes: 60,
      );
      expect(result, closeTo(600.0, 0.001));
    });
  });
}
