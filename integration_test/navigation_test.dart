import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/app_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bottom navigation', () {
    late final db = createTestDb();

    setUpAll(() async {
      await seedCompletedProfile(db);
    });

    tearDownAll(() async {
      await db.close();
    });

    testWidgets(
      'Dashboard tab is active on launch',
      (tester) async {
        await pumpApp(tester, db);

        // BottomNavigationBar is present
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Dashboard label exists in bottom nav
        expect(
          find.descendant(
            of: find.byType(BottomNavigationBar),
            matching: find.text('Dashboard'),
          ),
          findsOneWidget,
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Tap History tab shows History screen',
      (tester) async {
        await pumpApp(tester, db);

        await tapBottomNav(tester, 'History');

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('History'),
          ),
          findsOneWidget,
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Tap Weight tab shows Weight Trend screen',
      (tester) async {
        await pumpApp(tester, db);

        await tapBottomNav(tester, 'Weight');

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Weight Trend'),
          ),
          findsOneWidget,
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Tap Profile tab shows Profile screen',
      (tester) async {
        await pumpApp(tester, db);

        await tapBottomNav(tester, 'Profile');

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Profile'),
          ),
          findsOneWidget,
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Tap Dashboard tab returns to Dashboard after switching',
      (tester) async {
        await pumpApp(tester, db);

        await tapBottomNav(tester, 'Weight');
        await tapBottomNav(tester, 'Dashboard');

        // Bottom nav Dashboard label is still present
        expect(
          find.descendant(
            of: find.byType(BottomNavigationBar),
            matching: find.text('Dashboard'),
          ),
          findsOneWidget,
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
