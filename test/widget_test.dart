// Smoke test: the app builds and renders its first frame without throwing
// when backed by an in-memory Drift DB.
//
// This test intentionally does NOT use the real [appDatabaseProvider], because
// the production factory calls [driftDatabase(name: ...)] which depends on a
// platform path provider that `flutter test` does not initialise. Instead we
// inject an in-memory [AppDatabase] with `skipSeeding: true` via ProviderScope
// override — the same pattern the DAO tests use.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/app.dart';
import 'package:calorie_tracker/data/database/app_database.dart';

void main() {
  testWidgets('App smoke test — boots without throwing', (tester) async {
    final db = AppDatabase.forTesting(
      NativeDatabase.memory(),
      skipSeeding: true,
    );
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const CalorieTrackerApp(),
      ),
    );

    // The router shows a CircularProgressIndicator while
    // `onboardingCompleteProvider` resolves — that's the stable assertion on
    // the very first frame. We don't pumpAndSettle because downstream Drift
    // streams never complete.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Explicitly dispose the ProviderScope INSIDE the test body so we can
    // drain the zero-duration timer that Drift's StreamQueryStore schedules
    // in markAsClosed(). Without this pump the framework sees a pending timer
    // after the widget tree is torn down and fails the invariant check.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
  });
}
