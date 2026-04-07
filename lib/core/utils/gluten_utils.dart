import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Canonical gluten status values matching the DB CHECK constraint.
enum GlutenStatus {
  glutenFree('gluten_free'),
  containsGluten('contains_gluten'),
  mayContain('may_contain'),
  unknown('unknown');

  const GlutenStatus(this.value);
  final String value;

  static GlutenStatus fromString(String? raw) {
    return GlutenStatus.values.firstWhere(
      (s) => s.value == raw,
      orElse: () => GlutenStatus.unknown,
    );
  }
}

class GlutenUtils {
  GlutenUtils._();

  /// Returns true if the status should block or warn the user.
  static bool isRisky(GlutenStatus status) =>
      status == GlutenStatus.containsGluten ||
      status == GlutenStatus.mayContain ||
      status == GlutenStatus.unknown;

  static bool isRiskyString(String? status) =>
      isRisky(GlutenStatus.fromString(status));

  /// Human-readable label for a gluten status.
  static String label(GlutenStatus status) {
    switch (status) {
      case GlutenStatus.glutenFree:
        return 'Gluten Free';
      case GlutenStatus.containsGluten:
        return 'Contains Gluten';
      case GlutenStatus.mayContain:
        return 'May Contain Gluten';
      case GlutenStatus.unknown:
        return 'Gluten Status Unknown';
    }
  }

  static String labelFromString(String? status) =>
      label(GlutenStatus.fromString(status));

  /// Badge background color — adapts to light/dark mode via [context].
  static Color badgeColor(GlutenStatus status, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppColors.glutenColor(status.value, isDark: isDark);
  }

  static Color badgeColorFromString(String? status, BuildContext context) =>
      badgeColor(GlutenStatus.fromString(status), context);

  /// Icon to show alongside the badge.
  static IconData badgeIcon(GlutenStatus status) {
    switch (status) {
      case GlutenStatus.glutenFree:
        return Icons.check_circle_outline;
      case GlutenStatus.containsGluten:
        return Icons.cancel_outlined;
      case GlutenStatus.mayContain:
        return Icons.warning_amber_outlined;
      case GlutenStatus.unknown:
        return Icons.help_outline;
    }
  }
}
