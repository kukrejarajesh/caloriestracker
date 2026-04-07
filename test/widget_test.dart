import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CalorieTrackerApp()),
    );
    expect(find.text('Calorie Tracker'), findsOneWidget);
  });
}
