import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/lessons.dart';

void main() {
  test('the release lesson library is complete and drawable', () {
    expect(lessonsOf(LessonKind.letter).length, 26);
    for (final kind in LessonKind.values.where(
      (kind) => kind != LessonKind.letter,
    )) {
      expect(lessonsOf(kind).length, 20, reason: kind.name);
    }
    expect(lessons.length, 146);
    expect(lessons.map((lesson) => lesson.id).toSet().length, lessons.length);
    for (final lesson in lessons) {
      expect(lesson.strokes, isNotEmpty, reason: lesson.id);
      for (final stroke in lesson.strokes) {
        expect(stroke.length, greaterThan(1), reason: lesson.id);
        for (final point in stroke) {
          expect(point.dx, inInclusiveRange(0, 1), reason: lesson.id);
          expect(point.dy, inInclusiveRange(0, 1), reason: lesson.id);
        }
      }
    }
  });
}
