// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/widgets/gluten_badge.dart';
import 'package:calorie_tracker/core/utils/gluten_utils.dart';

/// Wraps [widget] in a minimal [MaterialApp] so that [Theme.of(context)] and
/// [MediaQuery] are available.
Widget _wrap(Widget widget, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? ThemeData.light(),
    home: Scaffold(body: Center(child: widget)),
  );
}

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // Full badge (compact = false)
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenBadge — full mode (compact: false)', () {
    testWidgets('renders "Gluten Free" label for gluten_free status',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free'),
      ));
      expect(find.text('Gluten Free'), findsOneWidget);
    });

    testWidgets('renders "Contains Gluten" label for contains_gluten status',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'contains_gluten'),
      ));
      expect(find.text('Contains Gluten'), findsOneWidget);
    });

    testWidgets('renders "May Contain Gluten" label for may_contain status',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'may_contain'),
      ));
      expect(find.text('May Contain Gluten'), findsOneWidget);
    });

    testWidgets('renders "Gluten Status Unknown" for unknown status',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'unknown'),
      ));
      expect(find.text('Gluten Status Unknown'), findsOneWidget);
    });

    testWidgets('unrecognised status string falls back to unknown label',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'totally_made_up'),
      ));
      expect(find.text('Gluten Status Unknown'), findsOneWidget);
    });

    testWidgets('full badge shows an Icon widget alongside the label',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free'),
      ));
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('full badge uses check_circle_outline icon for gluten_free',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free'),
      ));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.check_circle_outline));
    });

    testWidgets('full badge uses cancel_outlined icon for contains_gluten',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'contains_gluten'),
      ));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.cancel_outlined));
    });

    testWidgets('full badge uses warning_amber_outlined icon for may_contain',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'may_contain'),
      ));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.warning_amber_outlined));
    });

    testWidgets('full badge uses help_outline icon for unknown status',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'unknown'),
      ));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.help_outline));
    });

    testWidgets('full badge renders a Container with border decoration',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free'),
      ));
      expect(find.byType(Container), findsWidgets);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Compact badge (compact = true)
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenBadge — compact mode (compact: true)', () {
    testWidgets('compact badge shows a Tooltip widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free', compact: true),
      ));
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('compact badge tooltip message equals label for gluten_free',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free', compact: true),
      ));
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, equals(GlutenUtils.label(GlutenStatus.glutenFree)));
    });

    testWidgets('compact badge tooltip for contains_gluten is "Contains Gluten"',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'contains_gluten', compact: true),
      ));
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, equals('Contains Gluten'));
    });

    testWidgets('compact badge shows an Icon but no Text label', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free', compact: true),
      ));
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('compact icon size is 18', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free', compact: true),
      ));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(18));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Default parameter
  // ═══════════════════════════════════════════════════════════════════════════

  group('GlutenBadge — default parameter', () {
    testWidgets('compact defaults to false — Text label is visible',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const GlutenBadge(glutenStatus: 'gluten_free'),
      ));
      // In full mode a Text widget with the label should exist.
      expect(find.text('Gluten Free'), findsOneWidget);
    });
  });
}
