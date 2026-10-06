import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/app_state.dart';
import 'package:little_lines/drawing_canvas.dart';
import 'package:little_lines/main.dart';

void main() {
  testWidgets('a child can complete a lesson and save artwork', (tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final directory = Directory.systemTemp.createTempSync('little_lines_test_');
    addTearDown(() => directory.deleteSync(recursive: true));
    final state = AppState.forTesting(File('${directory.path}/state.json'));
    await tester.pumpWidget(
      AppScope(state: state, child: const LittleLinesApp()),
    );

    await tester.tap(find.text('Letters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A').first);
    await tester.pumpAndSettle();
    expect(find.text('A is for apple'), findsOneWidget);

    await tester.tap(find.text('Start tracing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Draw freely'));
    await tester.pumpAndSettle();

    final canvas = find.byType(FreeDrawingBoard);
    final rect = tester.getRect(canvas);
    await tester.dragFrom(
      rect.topLeft + const Offset(80, 80),
      const Offset(100, 160),
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Finish lesson'));
    await tester.tap(find.text('Finish lesson'));
    await tester.pumpAndSettle();

    expect(state.completed, contains('letter_A'));
    expect(state.gallery, hasLength(1));
    expect(find.text('You did it!'), findsOneWidget);
  });

  testWidgets('animal lesson fits an iPad layout', (tester) async {
    tester.view.physicalSize = const Size(2048, 2732);
    tester.view.devicePixelRatio = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final state = AppState.forTesting(File('/tmp/little_lines_ipad_test.json'));
    await tester.pumpWidget(
      AppScope(state: state, child: const LittleLinesApp()),
    );
    await tester.tap(find.text('Animals'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cat'));
    await tester.pumpAndSettle();
    expect(find.text('Draw a friendly cat'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a new drawing category opens from the home screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final state = AppState.forTesting(
      File('/tmp/little_lines_category_test.json'),
    );
    await tester.pumpWidget(
      AppScope(state: state, child: const LittleLinesApp()),
    );
    await tester.scrollUntilVisible(
      find.text('Food'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();
    expect(find.text('Pizza'), findsOneWidget);
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('A slice of pizza'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Avocado'));
    await tester.pumpAndSettle();
    expect(find.text("Let's draw Avocado"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
