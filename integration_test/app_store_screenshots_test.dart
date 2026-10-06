import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:little_lines/app_state.dart';
import 'package:little_lines/drawing_canvas.dart';
import 'package:little_lines/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture genuine App Store screens', (tester) async {
    final state = AppState.forTesting(
      File('${Directory.systemTemp.path}/store_shots.json'),
    );
    await tester.pumpWidget(
      AppScope(state: state, child: const LittleLinesApp()),
    );
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await tester.pump();
      // The host captures the whole Simulator display while this screen rests.
      // This includes the real status bar and avoids compositing UI mockups.
      // ignore: avoid_print
      print('SCREENSHOT_READY:$name');
      await Future<void>.delayed(const Duration(seconds: 8));
    }

    await capture('01_home');

    await tester.tap(find.text('Animals'));
    await capture('02_animals');
    await tester.tap(find.text('Cat'));
    await capture('03_cat_lesson');
    await tester.tap(find.text('Start tracing'));
    await capture('04_trace_cat');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Letters'));
    await capture('05_letters');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Numbers'));
    await capture('06_numbers');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Free drawing'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Free drawing'));
    await tester.pumpAndSettle();
    final board = tester.getRect(find.byType(FreeDrawingBoard));
    final left = board.left + board.width * .24;
    final right = board.left + board.width * .76;
    final top = board.top + board.height * .25;
    final bottom = board.top + board.height * .75;
    Future<void> drawLine(Offset start, Offset delta) async {
      await tester.dragFrom(start, delta);
      await tester.pump();
    }

    await drawLine(Offset(left, bottom), Offset(0, top - bottom));
    await drawLine(Offset(left, top), Offset(right - left, 0));
    await drawLine(Offset(right, top), Offset(0, bottom - top));
    await drawLine(Offset(right, bottom), Offset(left - right, 0));
    await drawLine(
      Offset(left, top),
      Offset((right - left) / 2, -(bottom - top) * .35),
    );
    await drawLine(
      Offset((left + right) / 2, top - (bottom - top) * .35),
      Offset((right - left) / 2, (bottom - top) * .35),
    );
    await capture('07_free_drawing');

    await tester.ensureVisible(find.text('Save to my gallery'));
    await tester.tap(find.text('Save to my gallery'));
    await tester.pumpAndSettle();
    await Future<void>.delayed(const Duration(seconds: 5));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('My gallery'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('My gallery'));
    await capture('08_gallery');
  });
}
