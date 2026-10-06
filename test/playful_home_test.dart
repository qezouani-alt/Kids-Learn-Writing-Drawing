import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/playful_home.dart';

void main() {
  testWidgets(
    'pencil responds to taps and fits a small screen with large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 720),
              textScaler: TextScaler.linear(1.3),
              disableAnimations: true,
            ),
            child: const Scaffold(
              body: SingleChildScrollView(
                child: PlayfulWelcome(completed: 3, total: 146),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Hello, little artist!'), findsOneWidget);
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(find.text('Wiggle your drawing fingers!'), findsOneWidget);
      expect(find.text('3 of 146 lessons finished'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
