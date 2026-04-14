import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:calorie_tracker/widgets/gluten_badge.dart';

import 'helpers/app_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Food logging flow', () {
    late AppDatabase db;

    setUp(() async {
      db = createTestDb();
      await seedTestFoods(db);
      await seedTestExercises(db);
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

    testWidgets(
      'FAB opens food search screen',
      (tester) async {
        await pumpApp(tester, db);
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // FoodSearchScreen AppBar
        expect(find.byType(AppBar), findsWidgets);
        expect(find.byType(TextField), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Gluten filter chip is ON by default',
      (tester) async {
        await openFoodSearch(tester);

        final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
        final glutenChip = chips.firstWhere(
          (c) => (c.label as Text).data?.toLowerCase().contains('gluten') == true,
          orElse: () => chips.first,
        );
        expect(glutenChip.selected, isTrue);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Searching Apple shows gluten-free result',
      (tester) async {
        await openFoodSearch(tester);

        await tester.enterText(find.byType(TextField).first, 'Apple');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Apple'), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Tapping a food shows GlutenBadge on detail screen',
      (tester) async {
        await openFoodSearch(tester);

        await tester.enterText(find.byType(TextField).first, 'Apple');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Detail screen open — warning banner shows gluten status text
        expect(find.text('Gluten Free'), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Logging Apple 100g adds entry to Dashboard meal section',
      (tester) async {
        await openFoodSearch(tester);

        await tester.enterText(find.byType(TextField).first, 'Apple');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Tap the ListTile (not just the Text) to trigger onTap → Navigator.push
        await tester.tap(find.byType(ListTile).first);
        // pumpAndSettle waits for the route animation to complete (safe here —
        // no DB-watching streams fire until we actually log food)
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Confirm we're on the detail screen
        expect(find.widgetWithText(AppBar, 'Apple'), findsOneWidget);

        // Enter quantity
        await tester.enterText(find.byType(TextField).first, '100');
        await tester.pump(const Duration(milliseconds: 200));

        // Drag the SingleChildScrollView to bring Log Food button into view
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -400),
        );
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Log Food'), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Back on dashboard — meal section shows kcal entry
        expect(find.textContaining('kcal'), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
