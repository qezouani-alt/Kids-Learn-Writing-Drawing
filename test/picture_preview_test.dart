import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/drawing_canvas.dart';
import 'package:little_lines/lessons.dart';

void main() {
  testWidgets('new picture lessons have recognizable guide previews', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final pictures = lessons
        .where(
          (lesson) => {
            LessonKind.shape,
            LessonKind.vehicle,
            LessonKind.nature,
            LessonKind.food,
          }.contains(lesson.kind),
        )
        .take(17)
        .toList();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          body: Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final lesson in pictures)
                  SizedBox(
                    width: 175,
                    height: 140,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: CustomPaint(
                            painter: LessonPreviewPainter(lesson),
                          ),
                        ),
                        Text(
                          lesson.title,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(Wrap),
      matchesGoldenFile('goldens/new_picture_categories.png'),
    );
  });
}
