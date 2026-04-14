import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/app_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding flow', () {
    late AppDatabase db;

    setUp(() async {
      db = createTestDb();
      await seedTestFoods(db);
      // No profile seeded — forces onboarding
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets(
      'Shows OnboardingScreen when no profile exists',
      (tester) async {
        await pumpApp(tester, db);

        expect(find.text('Personal Info'), findsOneWidget);
        expect(find.text('Step 1 of 4'), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsNothing);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Next button blocked when name field is empty',
      (tester) async {
        await pumpApp(tester, db);

        // Do not fill name — tap Next directly
        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Still on page 1
        expect(find.text('Step 1 of 4'), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'Gluten-free toggle is ON by default on page 4',
      (tester) async {
        await pumpApp(tester, db);

        // Page 1 — fill name
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'),
          'Test User',
        );
        await tester.pump(const Duration(milliseconds: 200));

        // Set DOB via date picker text-input mode
        await tester.tap(find.text('Select date'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Switch date picker to text input mode (pencil/keyboard icon)
        final editIcon = find.byIcon(Icons.edit_outlined);
        if (editIcon.evaluate().isNotEmpty) {
          await tester.tap(editIcon);
          await tester.pump(const Duration(milliseconds: 300));
        }
        // Enter date in text field within dialog
        final dateField = find.byType(TextField).last;
        await tester.enterText(dateField, '01/01/1990');
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.text('OK'));
        await tester.pump(const Duration(milliseconds: 300));

        // Select gender
        await tester.tap(find.widgetWithText(ChoiceChip, 'Male'));
        await tester.pump(const Duration(milliseconds: 200));

        // Next → Page 2
        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Page 2 — fill height and weight
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Height'),
          '175',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Weight'),
          '70',
        );
        await tester.pump(const Duration(milliseconds: 200));

        // Next → Page 3
        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Page 3 — tap any activity level
        await tester.tap(find.text('Sedentary'));
        await tester.pump(const Duration(milliseconds: 200));

        // Next → Page 4
        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Page 4 — verify gluten toggle is ON
        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isTrue);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    testWidgets(
      'Full happy path completes onboarding and shows Dashboard',
      (tester) async {
        await pumpApp(tester, db);

        // Page 1
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'),
          'Test User',
        );
        await tester.pump(const Duration(milliseconds: 200));

        // DOB — open picker and switch to text mode
        await tester.tap(find.text('Select date'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        final editIcon = find.byIcon(Icons.edit_outlined);
        if (editIcon.evaluate().isNotEmpty) {
          await tester.tap(editIcon);
          await tester.pump(const Duration(milliseconds: 300));
        }
        final dateField = find.byType(TextField).last;
        await tester.enterText(dateField, '01/01/1990');
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.text('OK'));
        await tester.pump(const Duration(milliseconds: 300));

        // Gender
        await tester.tap(find.widgetWithText(ChoiceChip, 'Male'));
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Page 2
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Height'),
          '175',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Weight'),
          '70',
        );
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Page 3
        await tester.tap(find.text('Moderately Active'));
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Page 4 — tap a goal
        await tester.tap(find.text('Maintain Weight'));
        await tester.pump(const Duration(milliseconds: 200));

        // Gluten toggle is ON by default — leave it
        await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
        await tester.pump(const Duration(milliseconds: 1000));
        await tester.pump(const Duration(milliseconds: 1000));

        // After onboarding, _AppRouter re-routes — BottomNavigationBar is shown
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
