import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:calorie_tracker/widgets/water_tracker.dart';

import 'helpers/app_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Water tracking on Dashboard', () {
    late AppDatabase db;

    setUp(() async {
      db = createTestDb();
      await seedCompletedProfile(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> scrollToWater(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.byType(WaterTracker),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 200));
    }

    testWidgets(
      'Quick-add +200ml chip updates water display',
      (tester) async {
        await pumpApp(tester, db);
        await scrollToWater(tester);

        await tester.tap(find.widgetWithText(ActionChip, '+200ml'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.textContaining('200ml'), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Three quick-adds of 200ml accumulate to 600ml',
      (tester) async {
        await pumpApp(tester, db);
        await scrollToWater(tester);

        for (var i = 0; i < 3; i++) {
          await tester.tap(find.widgetWithText(ActionChip, '+200ml'));
          await tester.pump(const Duration(milliseconds: 300));
        }
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.textContaining('600ml'), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Reaching water target shows Daily goal reached',
      (tester) async {
        await pumpApp(tester, db);
        await scrollToWater(tester);

        // 4 × 500ml = 2000ml — matches waterTargetMl in seeded profile
        for (var i = 0; i < 4; i++) {
          await tester.tap(find.widgetWithText(ActionChip, '+500ml'));
          await tester.pump(const Duration(milliseconds: 300));
        }
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.textContaining('Daily goal reached'), findsWidgets);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
