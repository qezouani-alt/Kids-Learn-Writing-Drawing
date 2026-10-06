import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:little_lines/app_state.dart';
import 'package:little_lines/main.dart';
import 'package:little_lines/screens.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Settings opens directly; Share protects external navigation', (
    tester,
  ) async {
    final state = AppState.forTesting(
      File('${Directory.systemTemp.path}/settings_device.json'),
    );
    await tester.pumpWidget(
      AppScope(state: state, child: const LittleLinesApp()),
    );

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(ParentPage), findsOneWidget);
    expect(find.text('For grown-ups'), findsNothing);

    await tester.scrollUntilVisible(find.text('Share this app'), 300);
    await tester.tap(find.text('Share this app'));
    await tester.pumpAndSettle();
    expect(find.text('For grown-ups'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Privacy policy'), 300);
    await tester.tap(find.text('Privacy policy'));
    await tester.pumpAndSettle();
    expect(find.text('For grown-ups'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
