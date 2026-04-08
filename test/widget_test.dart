import 'package:expense_tracker_tuf/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    // App starts on auth screen — just make sure it renders
    await tester.pump();
  });
}
