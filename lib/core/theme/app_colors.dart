import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // ── Gluten status — light mode ────────────────────────────────────────────
  static const Color glutenWarningLight = Color(0xFFD32F2F);
  static const Color glutenSafeLight = Color(0xFF388E3C);
  static const Color glutenMayContainLight = Color(0xFFF57C00);
  static const Color glutenUnknownLight = Color(0xFFF57C00);

  // ── Gluten status — dark mode ─────────────────────────────────────────────
  static const Color glutenWarningDark = Color(0xFFEF9A9A);
  static const Color glutenSafeDark = Color(0xFFA5D6A7);
  static const Color glutenMayContainDark = Color(0xFFFFCC80);
  static const Color glutenUnknownDark = Color(0xFFFFCC80);

  // ── Macros ────────────────────────────────────────────────────────────────
  static const Color protein = Color(0xFF1565C0);
  static const Color carbs = Color(0xFFF9A825);
  static const Color fat = Color(0xFFAD1457);
  static const Color fiber = Color(0xFF558B2F);

  // ── Surfaces ──────────────────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // ── Water ─────────────────────────────────────────────────────────────────
  static const Color water = Color(0xFF0288D1);

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns the gluten badge color for the given [status], adapting to [isDark].
  static Color glutenColor(String status, {bool isDark = false}) {
    switch (status) {
      case 'gluten_free':
        return isDark ? glutenSafeDark : glutenSafeLight;
      case 'contains_gluten':
        return isDark ? glutenWarningDark : glutenWarningLight;
      case 'may_contain':
        return isDark ? glutenMayContainDark : glutenMayContainLight;
      case 'unknown':
      default:
        return isDark ? glutenUnknownDark : glutenUnknownLight;
    }
  }
}
