import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/app_state.dart';
import 'package:little_lines/main.dart';
import 'package:little_lines/screens.dart';

void main() {
  Future<void> openSettings(WidgetTester tester, String filename) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetViewInsets();
    });
    final state = AppState.forTesting(File('/tmp/$filename'));
    await tester.pumpWidget(
      AppScope(state: state, child: const LittleLinesApp()),
    );
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  testWidgets('Settings opens directly; policy link asks an adult', (
    tester,
  ) async {
    await openSettings(tester, 'little_lines_settings_test.json');
    expect(find.byType(ParentPage), findsOneWidget);
    expect(find.text('For grown-ups'), findsNothing);

    await tester.scrollUntilVisible(find.text('Privacy policy'), 300);
    await tester.tap(find.text('Privacy policy'));
    await tester.pumpAndSettle();
    expect(find.text('For grown-ups'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(ParentPage), findsOneWidget);
    expect(find.text('Legal notices'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Share still asks an adult and is usable with the keyboard', (
    tester,
  ) async {
    await openSettings(tester, 'little_lines_share_gate_test.json');
    await tester.scrollUntilVisible(find.text('Share this app'), 300);
    await tester.tap(find.text('Share this app'));
    await tester.pumpAndSettle();
    expect(find.text('For grown-ups'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    tester.view.viewInsets = const FakeViewPadding(bottom: 900);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField), '14');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('For grown-ups'), findsNothing);
    expect(find.byType(ParentPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Rate is protected by the adult check', (tester) async {
    await openSettings(tester, 'little_lines_rate_test.json');
    await tester.scrollUntilVisible(find.text('Rate this app'), 300);
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rate this app'));
    await tester.pumpAndSettle();
    expect(find.text('For grown-ups'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(ParentPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
