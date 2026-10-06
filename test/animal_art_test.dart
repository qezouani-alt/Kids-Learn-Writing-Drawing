import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_lines/animal_art.dart';
import 'package:little_lines/lessons.dart';

void main() {
  testWidgets('five shaded animal references render consistently', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 240);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFFF8FAFF),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimalArt(id: 'animal_cat', size: 180),
                AnimalArt(id: 'animal_fish', size: 180),
                AnimalArt(id: 'animal_butterfly', size: 180),
                AnimalArt(id: 'animal_turtle', size: 180),
                AnimalArt(id: 'animal_bird', size: 180),
              ],
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/shaded_animals.png'),
    );
  });

  testWidgets('additional animal references have shaded previews', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 620);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final animals = lessonsOf(LessonKind.animal).skip(5).toList();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          body: Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final animal in animals)
                  AnimalArt(id: animal.id, size: 170),
              ],
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(Wrap),
      matchesGoldenFile('goldens/more_shaded_animals.png'),
    );
  });
}
