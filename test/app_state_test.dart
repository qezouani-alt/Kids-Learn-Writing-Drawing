import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('completed lessons and artwork are written to local storage', () async {
    final directory = Directory.systemTemp.createTempSync(
      'little_lines_store_',
    );
    try {
      final file = File('${directory.path}/state.json');
      final state = AppState.forPersistenceTesting(file);
      await state.finishLesson('letter_A', 'A', [
        const InkStroke([Offset(.2, .8), Offset(.5, .2)], Colors.purple),
      ]);

      final saved =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      expect(saved['completed'], contains('letter_A'));
      expect((saved['gallery'] as List), hasLength(1));
      expect((saved['gallery'] as List).first['strokes'], hasLength(1));
    } finally {
      directory.deleteSync(recursive: true);
    }
  });
}
