// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/core/utils/gluten_utils.dart';
import 'package:calorie_tracker/core/theme/app_colors.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenStatus.fromString
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenStatus.fromString', () {
    test('parses "gluten_free" correctly', () {
      expect(GlutenStatus.fromString('gluten_free'), GlutenStatus.glutenFree);
    });

    test('parses "contains_gluten" correctly', () {
      expect(GlutenStatus.fromString('contains_gluten'),
          GlutenStatus.containsGluten);
    });

    test('parses "may_contain" correctly', () {
      expect(GlutenStatus.fromString('may_contain'), GlutenStatus.mayContain);
    });

    test('parses "unknown" correctly', () {
      expect(GlutenStatus.fromString('unknown'), GlutenStatus.unknown);
    });

    test('unrecognised string falls back to unknown', () {
      expect(GlutenStatus.fromString('garbage_value'), GlutenStatus.unknown);
    });

    test('null falls back to unknown', () {
      expect(GlutenStatus.fromString(null), GlutenStatus.unknown);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenUtils.isRisky — safety classification
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenUtils.isRisky', () {
    test('contains_gluten is risky', () {
      expect(GlutenUtils.isRisky(GlutenStatus.containsGluten), isTrue);
    });

    test('may_contain is risky', () {
      expect(GlutenUtils.isRisky(GlutenStatus.mayContain), isTrue);
    });

    test('unknown is risky — must never be treated as safe', () {
      expect(
        GlutenUtils.isRisky(GlutenStatus.unknown),
        isTrue,
        reason: 'unknown status must be treated as risky per project rules',
      );
    });

    test('gluten_free is not risky', () {
      expect(GlutenUtils.isRisky(GlutenStatus.glutenFree), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenUtils.isRiskyString
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenUtils.isRiskyString', () {
    test('returns true for "contains_gluten"', () {
      expect(GlutenUtils.isRiskyString('contains_gluten'), isTrue);
    });

    test('returns true for "may_contain"', () {
      expect(GlutenUtils.isRiskyString('may_contain'), isTrue);
    });

    test('returns true for "unknown"', () {
      expect(GlutenUtils.isRiskyString('unknown'), isTrue);
    });

    test('returns true for null — null is treated as unknown, hence risky', () {
      expect(GlutenUtils.isRiskyString(null), isTrue);
    });

    test('returns true for unrecognised string — falls back to unknown', () {
      expect(GlutenUtils.isRiskyString('weird_value'), isTrue);
    });

    test('returns false for "gluten_free"', () {
      expect(GlutenUtils.isRiskyString('gluten_free'), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenUtils.label
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenUtils.label', () {
    test('gluten_free produces "Gluten Free"', () {
      expect(GlutenUtils.label(GlutenStatus.glutenFree), equals('Gluten Free'));
    });

    test('contains_gluten produces "Contains Gluten"', () {
      expect(GlutenUtils.label(GlutenStatus.containsGluten),
          equals('Contains Gluten'));
    });

    test('may_contain produces "May Contain Gluten"', () {
      expect(GlutenUtils.label(GlutenStatus.mayContain),
          equals('May Contain Gluten'));
    });

    test('unknown produces "Gluten Status Unknown"', () {
      expect(GlutenUtils.label(GlutenStatus.unknown),
          equals('Gluten Status Unknown'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenUtils.labelFromString
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenUtils.labelFromString', () {
    test('string "gluten_free" maps to "Gluten Free"', () {
      expect(GlutenUtils.labelFromString('gluten_free'), equals('Gluten Free'));
    });

    test('null maps to "Gluten Status Unknown"', () {
      expect(
          GlutenUtils.labelFromString(null), equals('Gluten Status Unknown'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenUtils.badgeIcon
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenUtils.badgeIcon', () {
    test('gluten_free uses check_circle_outline icon', () {
      expect(GlutenUtils.badgeIcon(GlutenStatus.glutenFree),
          equals(Icons.check_circle_outline));
    });

    test('contains_gluten uses cancel_outlined icon', () {
      expect(GlutenUtils.badgeIcon(GlutenStatus.containsGluten),
          equals(Icons.cancel_outlined));
    });

    test('may_contain uses warning_amber_outlined icon', () {
      expect(GlutenUtils.badgeIcon(GlutenStatus.mayContain),
          equals(Icons.warning_amber_outlined));
    });

    test('unknown uses help_outline icon', () {
      expect(GlutenUtils.badgeIcon(GlutenStatus.unknown),
          equals(Icons.help_outline));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // AppColors.glutenColor — color correctness
  // ═══════════════════════════════════════════════════════════════════════════

  group('AppColors.glutenColor — light mode', () {
    test('gluten_free returns glutenSafeLight', () {
      expect(AppColors.glutenColor('gluten_free', isDark: false),
          equals(AppColors.glutenSafeLight));
    });

    test('contains_gluten returns glutenWarningLight (red)', () {
      expect(AppColors.glutenColor('contains_gluten', isDark: false),
          equals(AppColors.glutenWarningLight));
    });

    test('may_contain returns glutenMayContainLight (amber)', () {
      expect(AppColors.glutenColor('may_contain', isDark: false),
          equals(AppColors.glutenMayContainLight));
    });

    test('unknown returns glutenUnknownLight (amber)', () {
      expect(AppColors.glutenColor('unknown', isDark: false),
          equals(AppColors.glutenUnknownLight));
    });

    test('unrecognised string defaults to unknown color (amber)', () {
      expect(AppColors.glutenColor('surprise', isDark: false),
          equals(AppColors.glutenUnknownLight));
    });
  });

  group('AppColors.glutenColor — dark mode', () {
    test('gluten_free returns glutenSafeDark', () {
      expect(AppColors.glutenColor('gluten_free', isDark: true),
          equals(AppColors.glutenSafeDark));
    });

    test('contains_gluten returns glutenWarningDark', () {
      expect(AppColors.glutenColor('contains_gluten', isDark: true),
          equals(AppColors.glutenWarningDark));
    });

    test('may_contain returns glutenMayContainDark', () {
      expect(AppColors.glutenColor('may_contain', isDark: true),
          equals(AppColors.glutenMayContainDark));
    });

    test('unknown returns glutenUnknownDark', () {
      expect(AppColors.glutenColor('unknown', isDark: true),
          equals(AppColors.glutenUnknownDark));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GlutenStatus enum — value round-trips
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenStatus enum values match DB strings', () {
    test('glutenFree.value == "gluten_free"', () {
      expect(GlutenStatus.glutenFree.value, equals('gluten_free'));
    });

    test('containsGluten.value == "contains_gluten"', () {
      expect(GlutenStatus.containsGluten.value, equals('contains_gluten'));
    });

    test('mayContain.value == "may_contain"', () {
      expect(GlutenStatus.mayContain.value, equals('may_contain'));
    });

    test('unknown.value == "unknown"', () {
      expect(GlutenStatus.unknown.value, equals('unknown'));
    });
  });
}
