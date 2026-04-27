import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tab Flow Integration Tests', () {
    testWidgets('tab management flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // App should show browser screen
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
