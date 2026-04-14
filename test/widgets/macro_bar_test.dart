// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/widgets/macro_bar.dart';

Widget _wrap(Widget widget, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? ThemeData.light(),
    home: Scaffold(body: Center(child: widget)),
  );
}

/// Pumps a [MacroBar] with the given values inside a bounded
/// container so layout doesn't overflow.
Future<void> _pump(
  WidgetTester tester, {
  double protein = 50,
  double proteinTarget = 150,
  double carbs = 100,
  double carbsTarget = 250,
  double fat = 30,
  double fatTarget = 65,
}) async {
  // Use a wide MediaQuery to give each macro column room so text does not
  // overflow during testing. Actual overflow in constrained devices is a UX
  // concern for manual testing, not a logic error.
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(1024, 768)),
      child: _wrap(
        SizedBox(
          width: 600,
          child: MacroBar(
            protein: protein,
            proteinTarget: proteinTarget,
            carbs: carbs,
            carbsTarget: carbsTarget,
            fat: fat,
            fatTarget: fatTarget,
          ),
        ),
      ),
    ),
  );
}

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // Rendering
  // ═══════════════════════════════════════════════════════════════════════════

  group('MacroBar — rendering', () {
    testWidgets('renders without throwing', (tester) async {
      await _pump(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows all three macro labels', (tester) async {
      await _pump(tester);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);
    });

    testWidgets('shows rounded gram values for each macro', (tester) async {
      await _pump(tester, protein: 53.6, carbs: 112.3, fat: 28.9);
      expect(find.text('54g'), findsOneWidget);
      expect(find.text('112g'), findsOneWidget);
      expect(find.text('29g'), findsOneWidget);
    });

    testWidgets('shows "of Xg" target text for each macro', (tester) async {
      await _pump(
          tester, proteinTarget: 150, carbsTarget: 250, fatTarget: 65);
      expect(find.text('of 150g'), findsOneWidget);
      expect(find.text('of 250g'), findsOneWidget);
      expect(find.text('of 65g'), findsOneWidget);
    });

    testWidgets('renders three LinearProgressIndicator widgets', (tester) async {
      await _pump(tester);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Progress clamp
  // ═══════════════════════════════════════════════════════════════════════════

  group('MacroBar — progress clamping', () {
    testWidgets('progress does not exceed 1.0 when value exceeds target',
        (tester) async {
      await _pump(
        tester,
        protein: 200, // over target of 150
        proteinTarget: 150,
      );
      // Find the first LinearProgressIndicator (protein).
      final indicators =
          tester.widgetList<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      final proteinBar = indicators.first;
      expect(proteinBar.value, lessThanOrEqualTo(1.0));
    });

    testWidgets('progress is 0.0 when consumed value is zero', (tester) async {
      await _pump(
        tester,
        protein: 0,
        proteinTarget: 150,
        carbs: 0,
        carbsTarget: 250,
        fat: 0,
        fatTarget: 65,
      );
      for (final bar in tester
          .widgetList<LinearProgressIndicator>(find.byType(LinearProgressIndicator))) {
        expect(bar.value, equals(0.0));
      }
    });

    testWidgets('progress is 0.0 when target is zero (avoids division by zero)',
        (tester) async {
      await _pump(
        tester,
        protein: 50,
        proteinTarget: 0, // zero target
        carbs: 100,
        carbsTarget: 0,
        fat: 30,
        fatTarget: 0,
      );
      for (final bar in tester
          .widgetList<LinearProgressIndicator>(find.byType(LinearProgressIndicator))) {
        expect(bar.value, equals(0.0));
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Layout
  // ═══════════════════════════════════════════════════════════════════════════

  group('MacroBar — layout', () {
    testWidgets('top-level widget is a Row with three expanded children',
        (tester) async {
      await _pump(tester);
      // There should be at least one Row at the top level.
      expect(find.byType(Row), findsWidgets);
      // Each expanded section is an Expanded widget.
      expect(find.byType(Expanded), findsNWidgets(3));
    });
  });
}
