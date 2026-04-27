import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/features/address_bar/presentation/widgets/address_bar_widget.dart';

void main() {
  group('AddressBarWidget', () {
    testWidgets('shows text field when editing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressBarWidget(
                onSubmit: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls onSubmit when URL entered', (WidgetTester tester) async {
      String? submittedUrl;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressBarWidget(
                onSubmit: (url) => submittedUrl = url,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'example.com');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pump();

      expect(submittedUrl, isNotNull);
    });
  });
}
