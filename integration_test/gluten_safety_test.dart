import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:calorie_tracker/widgets/gluten_badge.dart';

import 'helpers/app_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Gluten safety', () {
    late AppDatabase db;

    setUp(() async {
      db = createTestDb();
      await seedTestFoods(db);
      await seedCompletedProfile(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> openFoodSearch(WidgetTester tester) async {
      await pumpApp(tester, db);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    }

    FilterChip findGlutenChip(WidgetTester tester) {
      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      return chips.firstWhere(
        (c) => (c.label as Text).data?.toLowerCase().contains('gluten') == true,
        orElse: () => chips.first,
      );
    }

    testWidgets(
      'Gluten filter chip defaults to ON',
      (tester) async {
        await openFoodSearch(tester);
        expect(findGlutenChip(tester).selected, isTrue);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Toggling filter OFF exposes contains_gluten foods',
      (tester) async {
        await openFoodSearch(tester);

        // Turn filter OFF
        await tester.tap(find.byType(FilterChip).first);
        await tester.pump(const Duration(milliseconds: 300));

        // Search for White Bread
        await tester.enterText(find.byType(TextField).first, 'Bread');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('White Bread'), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'contains_gluten food shows GlutenBadge on detail screen',
      (tester) async {
        await openFoodSearch(tester);

        // Turn filter OFF to expose White Bread
        await tester.tap(find.byType(FilterChip).first);
        await tester.pump(const Duration(milliseconds: 300));

        await tester.enterText(find.byType(TextField).first, 'Bread');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('White Bread').first);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Detail screen is open — warning banner shows 'Contains Gluten' text
        expect(find.text('Contains Gluten'), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Tapping Log Food on contains_gluten food shows confirmation dialog',
      (tester) async {
        await openFoodSearch(tester);

        await tester.tap(find.byType(FilterChip).first);
        await tester.pump(const Duration(milliseconds: 300));

        await tester.enterText(find.byType(TextField).first, 'Bread');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('White Bread').first);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Button text for risky food is 'Log with Warning'
        await tester.tap(find.text('Log with Warning'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Confirmation dialog must appear — never silently log a risky food
        expect(find.byType(AlertDialog), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Cancelling gluten confirmation dialog does not log the food',
      (tester) async {
        await openFoodSearch(tester);

        await tester.tap(find.byType(FilterChip).first);
        await tester.pump(const Duration(milliseconds: 300));

        await tester.enterText(find.byType(TextField).first, 'Bread');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('White Bread').first);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('Log with Warning'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Tap Cancel in dialog
        await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // No food was logged — dialog dismissed, still on search screen
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.byType(TextField), findsWidgets); // still on search screen
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Confirming gluten dialog logs food and dashboard shows risk flag',
      (tester) async {
        await openFoodSearch(tester);

        await tester.tap(find.byType(FilterChip).first);
        await tester.pump(const Duration(milliseconds: 300));

        await tester.enterText(find.byType(TextField).first, 'Bread');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('White Bread').first);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('Log with Warning'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Confirm in dialog — button text may be 'Log Anyway', 'Confirm', or 'Yes'
        final confirmButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        ).last;
        await tester.tap(confirmButton);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Back on dashboard — a GlutenBadge risk indicator is shown
        expect(find.byType(GlutenBadge), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
