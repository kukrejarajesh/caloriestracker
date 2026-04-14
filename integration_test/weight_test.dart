import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/app_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weight logging', () {
    late AppDatabase db;

    setUp(() async {
      db = createTestDb();
      await seedCompletedProfile(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> goToWeightTab(WidgetTester tester) async {
      await pumpApp(tester, db);
      await tapBottomNav(tester, 'Weight');
    }

    Future<void> enterAndLogWeight(WidgetTester tester, String value) async {
      final field = find.descendant(
        of: find.byType(TextField),
        matching: find.byType(EditableText),
      ).first;
      await tester.enterText(find.byType(TextField).first, value);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets(
      'Valid weight logs and appears in history',
      (tester) async {
        await goToWeightTab(tester);

        await tester.enterText(find.byType(TextField).first, '70.5');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Snackbar confirms
        expect(find.textContaining('70.5'), findsWidgets);
        // History entry
        expect(find.text('70.5 kg'), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Invalid weight below 20 shows error snackbar',
      (tester) async {
        await goToWeightTab(tester);

        await tester.enterText(find.byType(TextField).first, '10');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(
          find.text('Enter a valid weight (20–500 kg)'),
          findsOneWidget,
        );
        // No history entry
        expect(find.text('10 kg'), findsNothing);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Two entries show chart',
      (tester) async {
        await goToWeightTab(tester);

        // First entry
        await tester.enterText(find.byType(TextField).first, '70.0');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Second entry
        await tester.enterText(find.byType(TextField).first, '71.0');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.textContaining('Last 2 entries'), findsOneWidget);
        expect(find.byType(LineChart), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Delete weight entry removes it from history',
      (tester) async {
        await goToWeightTab(tester);

        // Log one entry
        await tester.enterText(find.byType(TextField).first, '72.0');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('72.0 kg'), findsOneWidget);

        // Delete it
        await tester.tap(find.byIcon(Icons.delete_outline).first);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('72.0 kg'), findsNothing);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
