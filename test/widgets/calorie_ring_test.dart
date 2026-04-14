// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:calorie_tracker/widgets/calorie_ring.dart';

Widget _wrap(Widget widget, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? ThemeData.light(),
    home: Scaffold(body: Center(child: widget)),
  );
}

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // Rendering sanity
  // ═══════════════════════════════════════════════════════════════════════════

  group('CalorieRing — rendering', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 800, target: 2000, burned: 200),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders a PieChart widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 800, target: 2000, burned: 0),
      ));
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('displays the consumed calorie count as text', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 1234, target: 2000, burned: 0),
      ));
      expect(find.text('1234'), findsOneWidget);
    });

    testWidgets('displays the target as "of <target> kcal"', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 500, target: 1800, burned: 0),
      ));
      expect(find.text('of 1800 kcal'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Normal state (within goal)
  // ═══════════════════════════════════════════════════════════════════════════

  group('CalorieRing — within goal', () {
    testWidgets('shows "Remaining" label when under goal', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 800, target: 2000, burned: 0),
      ));
      expect(find.textContaining('Remaining'), findsOneWidget);
    });

    testWidgets('shows correct remaining kcal text when under goal',
        (tester) async {
      // consumed=800, burned=200, target=2000  → net=600, remaining=1400
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 800, target: 2000, burned: 200),
      ));
      expect(find.textContaining('1400 kcal'), findsOneWidget);
    });

    testWidgets('does NOT show "Over goal" when within goal', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 1000, target: 2000, burned: 0),
      ));
      expect(find.textContaining('Over goal'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Over-goal state
  // ═══════════════════════════════════════════════════════════════════════════

  group('CalorieRing — over goal', () {
    testWidgets('shows "Over goal" label when consumed exceeds target',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 2500, target: 2000, burned: 0),
      ));
      expect(find.textContaining('Over goal'), findsOneWidget);
    });

    testWidgets('shows overage amount with plus sign when over goal',
        (tester) async {
      // consumed=2500, burned=0, target=2000 → over = 500
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 2500, target: 2000, burned: 0),
      ));
      expect(find.textContaining('+500 kcal'), findsOneWidget);
    });

    testWidgets('exercise burn reduces net calories and can pull back from over-goal',
        (tester) async {
      // consumed=2200, burned=300, target=2000 → net=1900, remaining=100
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 2200, target: 2000, burned: 300),
      ));
      expect(find.textContaining('Remaining'), findsOneWidget);
      expect(find.textContaining('Over goal'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Edge cases
  // ═══════════════════════════════════════════════════════════════════════════

  group('CalorieRing — edge cases', () {
    testWidgets('all zeros render without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 0, target: 0, burned: 0),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('exactly at goal shows Remaining with 0 kcal', (tester) async {
      // consumed=2000, burned=0, target=2000 → net=2000, remaining=0
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 2000, target: 2000, burned: 0),
      ));
      // Remaining should show 0 kcal but still use "Remaining" label.
      expect(find.textContaining('Remaining'), findsOneWidget);
    });

    testWidgets('widget is 200x200 in size', (tester) async {
      await tester.pumpWidget(_wrap(
        const CalorieRing(consumed: 500, target: 2000, burned: 100),
      ));
      final sizebox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizebox.width, equals(200));
      expect(sizebox.height, equals(200));
    });
  });
}
