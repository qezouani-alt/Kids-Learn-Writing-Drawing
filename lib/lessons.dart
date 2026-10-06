import 'dart:math' as math;

import 'package:flutter/material.dart';

part 'more_lessons.dart';

enum LessonKind { letter, number, animal, shape, vehicle, nature, food }

class LessonData {
  const LessonData({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.prompt,
    required this.strokes,
    required this.color,
    required this.icon,
  });

  final String id;
  final LessonKind kind;
  final String title;
  final String subtitle;
  final String prompt;
  final List<List<Offset>> strokes;
  final Color color;
  final IconData icon;
}

List<Offset> _line(String data) => data.split(' ').map((pair) {
  final values = pair.split(',');
  return Offset(double.parse(values[0]) / 100, double.parse(values[1]) / 100);
}).toList();

List<Offset> _ellipse(
  double x,
  double y,
  double rx,
  double ry, [
  int points = 28,
]) => List.generate(points + 1, (i) {
  final a = i * 2 * math.pi / points;
  return Offset((x + rx * math.cos(a)) / 100, (y + ry * math.sin(a)) / 100);
});

List<Offset> _arc(double x, double y, double rx, double ry) =>
    List.generate(19, (i) {
      final a = math.pi + i * math.pi / 18;
      return Offset((x + rx * math.cos(a)) / 100, (y + ry * math.sin(a)) / 100);
    });

LessonData _letter(String name, List<String> paths, String word) => LessonData(
  id: 'letter_$name',
  kind: LessonKind.letter,
  title: name,
  subtitle: '$name is for $word',
  prompt:
      'Let us draw the letter $name. Start at the bright dot and follow the line.',
  strokes: paths.map(_line).toList(),
  color: const Color(0xFF7459D9),
  icon: Icons.abc_rounded,
);

LessonData _number(String name, List<String> paths) =>
    _numberWithStrokes(name, paths.map(_line).toList());

LessonData _numberWithStrokes(
  String name,
  List<List<Offset>> strokes,
) => LessonData(
  id: 'number_$name',
  kind: LessonKind.number,
  title: name,
  subtitle: '$name ${name == '1' ? 'star' : 'stars'}',
  prompt: name == '0'
      ? 'Zero means no stars yet. Let us draw zero. Start at the bright dot.'
      : 'Count the $name ${name == '1' ? 'star' : 'stars'}. Now draw $name. Start at the bright dot.',
  strokes: strokes,
  color: const Color(0xFFED8E45),
  icon: Icons.onetwothree_rounded,
);

LessonData _animal(
  String id,
  String title,
  String subtitle,
  List<List<Offset>> strokes,
) => LessonData(
  id: 'animal_$id',
  kind: LessonKind.animal,
  title: title,
  subtitle: subtitle,
  prompt: 'Let us draw a $title, one shape at a time.',
  strokes: strokes,
  color: const Color(0xFF2EAD98),
  icon: Icons.pets_rounded,
);

LessonData _picture(
  LessonKind kind,
  String id,
  String title,
  String subtitle,
  List<List<Offset>> strokes,
) {
  final (color, icon) = switch (kind) {
    LessonKind.shape => (const Color(0xFFBA65CE), Icons.category_rounded),
    LessonKind.vehicle => (
      const Color(0xFF4186CE),
      Icons.directions_car_rounded,
    ),
    LessonKind.nature => (const Color(0xFF57A85B), Icons.park_rounded),
    LessonKind.food => (const Color(0xFFE66D70), Icons.restaurant_rounded),
    _ => throw ArgumentError('Unsupported picture category: $kind'),
  };
  return LessonData(
    id: '${kind.name}_$id',
    kind: kind,
    title: title,
    subtitle: subtitle,
    prompt: 'Let us draw $title, one shape at a time.',
    strokes: strokes,
    color: color,
    icon: icon,
  );
}

final List<LessonData> _baseLessons = [
  _letter('A', ['50,18 20,82', '50,18 80,82', '32,59 68,59'], 'apple'),
  _letter('B', [
    '28,18 28,82',
    '28,18 59,18 70,25 70,40 60,49 28,49',
    '28,49 63,49 75,57 75,72 64,82 28,82',
  ], 'ball'),
  _letter('C', [
    '73,25 61,18 42,18 27,30 22,50 27,70 42,82 61,82 73,75',
  ], 'cat'),
  _letter('D', [
    '27,18 27,82',
    '27,18 49,18 66,25 76,40 76,60 66,75 49,82 27,82',
  ], 'dog'),
  _letter('E', [
    '28,18 28,82',
    '28,18 72,18',
    '28,50 63,50',
    '28,82 72,82',
  ], 'elephant'),
  _letter('F', ['28,18 28,82', '28,18 73,18', '28,50 63,50'], 'fish'),
  _letter('G', [
    '73,27 61,18 42,18 28,30 23,50 28,70 42,82 63,82 75,69 75,52 56,52',
  ], 'grapes'),
  _letter('H', ['27,18 27,82', '73,18 73,82', '27,50 73,50'], 'hat'),
  _letter('I', ['30,18 70,18', '50,18 50,82', '30,82 70,82'], 'ice cream'),
  _letter('J', [
    '34,18 75,18',
    '65,18 65,67 58,79 44,83 31,78 25,67',
  ], 'jellyfish'),
  _letter('K', ['27,18 27,82', '73,18 28,55', '47,43 75,82'], 'kite'),
  _letter('L', ['28,18 28,82 73,82'], 'lion'),
  _letter('M', [
    '20,18 20,82',
    '20,18 50,57',
    '80,18 50,57',
    '80,18 80,82',
  ], 'moon'),
  _letter('N', ['25,18 25,82', '25,18 75,82', '75,18 75,82'], 'nest'),
  _letter('O', [
    '50,18 67,23 77,38 77,62 67,77 50,82 33,77 23,62 23,38 33,23 50,18',
  ], 'orange'),
  _letter('P', [
    '27,18 27,82',
    '27,18 57,18 72,27 72,42 58,51 27,51',
  ], 'pencil'),
  _letter('Q', [
    '50,18 67,23 77,38 77,62 67,77 50,82 33,77 23,62 23,38 33,23 50,18',
    '58,69 78,88',
  ], 'queen'),
  _letter('R', [
    '27,18 27,82',
    '27,18 58,18 72,27 72,43 58,52 27,52',
    '51,52 75,82',
  ], 'rainbow'),
  _letter('S', [
    '73,26 60,18 42,18 28,28 28,41 42,50 61,52 74,61 73,73 59,82 40,82 27,74',
  ], 'sun'),
  _letter('T', ['20,18 80,18', '50,18 50,82'], 'tiger'),
  _letter('U', ['25,18 25,63 31,77 50,82 69,77 75,63 75,18'], 'umbrella'),
  _letter('V', ['22,18 50,82 78,18'], 'violin'),
  _letter('W', ['17,18 32,82 50,42 68,82 83,18'], 'whale'),
  _letter('X', ['25,18 75,82', '75,18 25,82'], 'xylophone'),
  _letter('Y', ['23,18 50,50', '77,18 50,50', '50,50 50,82'], 'yoyo'),
  _letter('Z', ['25,18 75,18 25,82 75,82'], 'zebra'),
  _number('0', [
    '50,18 67,23 77,38 77,62 67,77 50,82 33,77 23,62 23,38 33,23 50,18',
  ]),
  _number('1', ['32,37 50,18 50,82', '34,82 68,82']),
  _number('2', ['26,34 32,23 48,18 65,22 73,34 69,47 54,59 26,82 75,82']),
  _number('3', [
    '28,25 44,18 61,19 72,30 66,43 52,50 66,55 73,68 62,80 43,82 28,75',
  ]),
  _number('4', ['60,18 26,62 77,62', '66,18 66,82']),
  _number('5', ['72,18 31,18 27,48 45,44 64,48 74,62 69,76 54,82 38,80 26,73']),
  _number('6', [
    '69,23 53,18 36,28 27,47 28,67 39,80 57,82 72,72 71,56 59,47 42,48 29,59',
  ]),
  _number('7', ['25,18 76,18 40,82']),
  _number('8', [
    '50,50 34,43 29,30 38,19 51,18 64,22 70,34 62,45 50,50 33,56 27,68 36,80 50,82 65,79 73,67 66,56 50,50',
  ]),
  _number('9', [
    '67,45 53,52 38,48 28,37 31,24 44,18 59,19 71,30 72,52 65,72 49,82 33,78',
  ]),
  _animal('cat', 'Cat', 'Draw a friendly cat', [
    _line('20,44 23,16 40,29 60,29 77,16 80,44'),
    _line('20,44 22,64 36,79 50,83 64,79 78,64 80,44'),
    _ellipse(38, 49, 3, 4),
    _ellipse(62, 49, 3, 4),
    _line('45,63 50,67 55,63 45,63'),
    _line('50,67 45,72'),
    _line('50,67 55,72'),
    _line('31,64 18,61'),
    _line('31,70 18,73'),
    _line('69,64 82,61'),
    _line('69,70 82,73'),
  ]),
  _animal('fish', 'Fish', 'Draw a swimming fish', [
    _ellipse(47, 52, 29, 21),
    _line('73,52 88,33 88,71 73,52'),
    _line('41,34 51,19 59,35'),
    _ellipse(34, 47, 3, 3),
    _line('23,60 31,63 39,60'),
    _ellipse(81, 21, 4, 4),
  ]),
  _animal('butterfly', 'Butterfly', 'Draw colorful wings', [
    _line('50,29 50,76'),
    _line('49,36 31,17 17,25 22,46 43,54 49,36'),
    _line('51,36 69,17 83,25 78,46 57,54 51,36'),
    _line('43,55 27,50 20,66 35,78 49,66'),
    _line('57,55 73,50 80,66 65,78 51,66'),
    _line('50,30 41,19'),
    _line('50,30 59,19'),
  ]),
  _animal('turtle', 'Turtle', 'Draw a little turtle', [
    _line('20,64 25,43 40,30 60,30 75,43 80,64 20,64'),
    _line('20,64 29,75 68,75 80,64'),
    _ellipse(80, 53, 10, 10),
    _ellipse(83, 49, 2, 2),
    _line('30,72 27,83 38,83 42,75'),
    _line('59,75 63,83 74,83 70,72'),
    _line('34,48 50,39 66,48 62,63 38,63 34,48'),
  ]),
  _animal('bird', 'Bird', 'Draw a chirping bird', [
    _ellipse(48, 55, 27, 23),
    _line('22,56 11,43 20,70'),
    _line('71,50 88,57 72,64'),
    _line('37,56 46,45 61,48 57,65 41,67 37,56'),
    _ellipse(61, 45, 2, 2),
    _line('41,77 40,86'),
    _line('55,77 56,86'),
  ]),
  _picture(LessonKind.shape, 'circle', 'Circle', 'A round shape', [
    _ellipse(50, 50, 31, 31),
  ]),
  _picture(LessonKind.shape, 'square', 'Square', 'Four equal sides', [
    _line('21,21 79,21 79,79 21,79 21,21'),
  ]),
  _picture(LessonKind.shape, 'triangle', 'Triangle', 'Three sides', [
    _line('50,18 82,79 18,79 50,18'),
  ]),
  _picture(LessonKind.shape, 'star', 'Star', 'Five bright points', [
    _line('50,13 60,39 87,39 65,56 73,84 50,67 27,84 35,56 13,39 40,39 50,13'),
  ]),
  _picture(LessonKind.shape, 'heart', 'Heart', 'A happy heart', [
    _line('50,79 27,58 19,43 23,29 35,23 50,36 65,23 77,29 81,43 73,58 50,79'),
  ]),
  _picture(LessonKind.vehicle, 'car', 'Car', 'Draw a little car', [
    _line('15,64 20,47 36,43 46,27 65,27 76,43 85,49 85,66 15,66 15,64'),
    _line('40,43 50,32 62,32 71,43 40,43'),
    _ellipse(31, 69, 9, 9),
    _ellipse(70, 69, 9, 9),
    _line('19,54 27,54'),
    _line('76,54 84,54'),
  ]),
  _picture(LessonKind.vehicle, 'boat', 'Boat', 'Sail across the water', [
    _line('18,62 83,62 70,77 35,77 18,62'),
    _line('50,20 50,62'),
    _line('47,22 25,58 47,58 47,22'),
    _line('53,27 75,58 53,58 53,27'),
    _line('13,83 29,80 44,83 59,80 75,83 87,80'),
  ]),
  _picture(LessonKind.vehicle, 'airplane', 'Airplane', 'Fly through the sky', [
    _line('12,49 75,49 87,53 75,57 12,57 12,49'),
    _line('42,49 55,23 66,23 59,49'),
    _line('42,57 55,78 66,78 59,57'),
    _line('23,49 16,36 25,36 36,49'),
    _ellipse(70, 53, 2, 2),
  ]),
  _picture(LessonKind.vehicle, 'bus', 'Bus', 'A bus with windows', [
    _line('16,29 76,29 83,38 83,70 16,70 16,29'),
    _line('24,38 38,38 38,52 24,52 24,38'),
    _line('44,38 58,38 58,52 44,52 44,38'),
    _line('64,38 75,38 75,52 64,52 64,38'),
    _ellipse(31, 73, 7, 7),
    _ellipse(68, 73, 7, 7),
  ]),
  _picture(LessonKind.nature, 'tree', 'Tree', 'A leafy tree', [
    _line('42,62 42,86 59,86 59,62'),
    _ellipse(50, 41, 29, 25),
    _line('19,85 82,85'),
  ]),
  _picture(LessonKind.nature, 'flower', 'Flower', 'A flower in bloom', [
    _line('50,56 50,86'),
    _line('50,72 33,63 42,76'),
    _line('50,76 67,65 57,79'),
    _ellipse(50, 42, 9, 9),
    _ellipse(50, 22, 8, 12),
    _ellipse(70, 41, 12, 8),
    _ellipse(50, 61, 8, 11),
    _ellipse(30, 41, 12, 8),
  ]),
  _picture(LessonKind.nature, 'sun', 'Sun', 'A warm sun', [
    _ellipse(50, 50, 19, 19),
    _line('50,15 50,25'),
    _line('50,75 50,85'),
    _line('15,50 25,50'),
    _line('75,50 85,50'),
    _line('25,25 32,32'),
    _line('68,68 75,75'),
    _line('75,25 68,32'),
    _line('32,68 25,75'),
  ]),
  _picture(LessonKind.nature, 'rainbow', 'Rainbow', 'Colors in the sky', [
    _arc(50, 77, 38, 49),
    _arc(50, 77, 29, 38),
    _arc(50, 77, 20, 27),
    _line('8,79 27,79'),
    _line('73,79 92,79'),
  ]),
  _picture(LessonKind.food, 'apple', 'Apple', 'A crunchy apple', [
    _line(
      '50,36 37,28 24,34 20,50 25,68 40,81 50,77 60,81 75,68 80,50 76,34 63,28 50,36',
    ),
    _line('50,35 51,19'),
    _line('52,24 63,17 70,21 62,28 52,24'),
  ]),
  _picture(LessonKind.food, 'ice_cream', 'Ice Cream', 'A tasty treat', [
    _line('29,48 50,86 71,48'),
    _ellipse(50, 40, 24, 19),
    _ellipse(50, 19, 5, 5),
    _line('38,64 62,64'),
  ]),
  _picture(LessonKind.food, 'cupcake', 'Cupcake', 'A sweet cupcake', [
    _line('28,55 72,55 65,83 35,83 28,55'),
    _line('26,54 30,43 39,39 43,28 57,28 61,39 70,43 74,54 26,54'),
    _ellipse(50, 25, 5, 5),
    _line('43,62 46,77'),
    _line('56,62 54,77'),
  ]),
  _picture(LessonKind.food, 'pizza', 'Pizza', 'A slice of pizza', [
    _line('17,26 83,26 50,84 17,26'),
    _line('17,26 27,20 73,20 83,26'),
    _ellipse(43, 39, 5, 5),
    _ellipse(59, 43, 5, 5),
    _ellipse(50, 61, 5, 5),
  ]),
];

List<LessonData> _teenNumbers() {
  final digits = {
    for (final lesson in _baseLessons.where(
      (item) => item.kind == LessonKind.number,
    ))
      int.parse(lesson.title): lesson.strokes,
  };
  List<List<Offset>> place(List<List<Offset>> strokes, double left) => strokes
      .map(
        (stroke) => stroke
            .map((point) => Offset(left + point.dx * .43, .06 + point.dy * .88))
            .toList(),
      )
      .toList();
  return List.generate(10, (index) {
    final value = 10 + index;
    return _numberWithStrokes('$value', [
      ...place(digits[1]!, .03),
      ...place(digits[index]!, .53),
    ]);
  });
}

final List<LessonData> lessons = [
  ..._baseLessons,
  ..._teenNumbers(),
  ..._moreLessons(),
];

List<LessonData> lessonsOf(LessonKind kind) =>
    lessons.where((lesson) => lesson.kind == kind).toList();
