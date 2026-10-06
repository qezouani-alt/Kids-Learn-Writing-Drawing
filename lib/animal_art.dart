import 'package:flutter/material.dart';

import 'lessons.dart';

/// Shaded, vector animal references. The tracing paths remain separate and
/// simple enough for a child to follow with a finger.
class AnimalArt extends StatelessWidget {
  const AnimalArt({super.key, required this.id, this.size = 140});

  final String id;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: AnimalArtPainter(id)),
  );
}

class AnimalArtPainter extends CustomPainter {
  const AnimalArtPainter(this.id);
  final String id;

  Path _polygon(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  Path _oval(double x, double y, double rx, double ry) => Path()
    ..addOval(
      Rect.fromCenter(center: Offset(x, y), width: rx * 2, height: ry * 2),
    );

  void _shade(
    Canvas canvas,
    Path path,
    Rect bounds,
    Color light,
    Color dark, {
    bool shadow = false,
    Color outline = const Color(0x5532424D),
  }) {
    if (shadow) canvas.drawShadow(path, const Color(0x600C2142), 4, false);
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, dark],
        ).createShader(bounds),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = outline,
    );
  }

  void _line(
    Canvas canvas,
    List<Offset> points,
    Color color, [
    double width = 1.7,
  ]) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  void _glint(Canvas canvas, double x, double y, double rx, double ry) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: rx * 2, height: ry * 2),
      Paint()..color = Colors.white.withValues(alpha: .55),
    );
  }

  void _eye(Canvas canvas, double x, double y, {double r = 2.5}) {
    canvas.drawCircle(
      Offset(x, y),
      r,
      Paint()..color = const Color(0xFF233443),
    );
    canvas.drawCircle(
      Offset(x - .7, y - .8),
      r * .28,
      Paint()..color = Colors.white,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    canvas.drawOval(
      const Rect.fromLTWH(22, 85, 58, 7),
      Paint()..color = const Color(0x220C2142),
    );
    switch (id) {
      case 'animal_cat':
        _cat(canvas);
      case 'animal_fish':
        _fish(canvas);
      case 'animal_butterfly':
        _butterfly(canvas);
      case 'animal_turtle':
        _turtle(canvas);
      case 'animal_bird':
        _bird(canvas);
      default:
        _genericAnimal(canvas);
    }
    canvas.restore();
  }

  void _genericAnimal(Canvas canvas) {
    final matches = lessons.where((lesson) => lesson.id == id);
    if (matches.isEmpty) return;
    final base = switch (id) {
      'animal_dog' => const Color(0xFFC58A58),
      'animal_rabbit' => const Color(0xFFD8C6EA),
      'animal_bear' => const Color(0xFFB88862),
      'animal_elephant' => const Color(0xFF9DB9C5),
      'animal_lion' => const Color(0xFFE6AB53),
      'animal_monkey' => const Color(0xFFB17E62),
      'animal_giraffe' => const Color(0xFFF0BE62),
      'animal_zebra' => const Color(0xFFE3E7E9),
      'animal_whale' => const Color(0xFF72B3D9),
      'animal_frog' => const Color(0xFF85BF6F),
      'animal_owl' => const Color(0xFFAA8CB9),
      'animal_bee' => const Color(0xFFFFD56B),
      'animal_ladybug' => const Color(0xFFE76E6A),
      'animal_snail' => const Color(0xFFC8A7CF),
      'animal_crab' => const Color(0xFFF29677),
      _ => const Color(0xFFA4CFB5),
    };
    final light = Color.lerp(base, Colors.white, .48)!;
    final dark = Color.lerp(base, Colors.black, .25)!;
    var highlighted = false;
    for (final stroke in matches.first.strokes) {
      if (stroke.length < 2) continue;
      final points = stroke.map((p) => Offset(p.dx * 100, p.dy * 100)).toList();
      final closed = (points.first - points.last).distance < 3;
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      if (closed) path.close();
      final bounds = path.getBounds();
      if (closed && bounds.width > 8 && bounds.height > 8) {
        _shade(
          canvas,
          path,
          bounds,
          light,
          dark,
          shadow: !highlighted,
          outline: Color.lerp(dark, Colors.black, .15)!,
        );
        if (!highlighted && bounds.width > 25) {
          _glint(
            canvas,
            bounds.left + bounds.width * .34,
            bounds.top + bounds.height * .22,
            bounds.width * .17,
            bounds.height * .06,
          );
          highlighted = true;
        }
      } else if (closed) {
        canvas.drawPath(path, Paint()..color = const Color(0xFF344050));
      } else {
        _line(canvas, points, const Color(0xFF45505B), 1.7);
      }
    }
  }

  void _cat(Canvas c) {
    final leftEar = _polygon(const [
      Offset(22, 43),
      Offset(22, 12),
      Offset(43, 29),
    ]);
    final rightEar = _polygon(const [
      Offset(57, 29),
      Offset(78, 12),
      Offset(78, 43),
    ]);
    _shade(
      c,
      leftEar,
      const Rect.fromLTWH(20, 12, 24, 32),
      const Color(0xFFFFD38C),
      const Color(0xFFD9844B),
      shadow: true,
    );
    _shade(
      c,
      rightEar,
      const Rect.fromLTWH(56, 12, 24, 32),
      const Color(0xFFFFD38C),
      const Color(0xFFD9844B),
      shadow: true,
    );
    _shade(
      c,
      _polygon(const [Offset(28, 34), Offset(28, 23), Offset(39, 34)]),
      const Rect.fromLTWH(28, 23, 11, 11),
      const Color(0xFFFFB8B1),
      const Color(0xFFE78088),
    );
    _shade(
      c,
      _polygon(const [Offset(61, 34), Offset(72, 23), Offset(72, 34)]),
      const Rect.fromLTWH(61, 23, 11, 11),
      const Color(0xFFFFB8B1),
      const Color(0xFFE78088),
    );
    _shade(
      c,
      _oval(50, 52, 32, 29),
      const Rect.fromLTWH(18, 23, 64, 58),
      const Color(0xFFFFD893),
      const Color(0xFFE39451),
      shadow: true,
    );
    _glint(c, 35, 37, 12, 6);
    _shade(
      c,
      _oval(39, 57, 10, 8),
      const Rect.fromLTWH(29, 49, 20, 16),
      const Color(0xFFFFF5DE),
      const Color(0xFFEFD8B8),
      outline: Colors.transparent,
    );
    _shade(
      c,
      _oval(61, 57, 10, 8),
      const Rect.fromLTWH(51, 49, 20, 16),
      const Color(0xFFFFF5DE),
      const Color(0xFFEFD8B8),
      outline: Colors.transparent,
    );
    _eye(c, 38, 47);
    _eye(c, 62, 47);
    _shade(
      c,
      _polygon(const [Offset(45, 60), Offset(55, 60), Offset(50, 65)]),
      const Rect.fromLTWH(45, 60, 10, 5),
      const Color(0xFFFF9DA6),
      const Color(0xFFDD6276),
    );
    _line(c, const [Offset(50, 65), Offset(45, 70)], const Color(0xFF754B45));
    _line(c, const [Offset(50, 65), Offset(55, 70)], const Color(0xFF754B45));
    for (final y in [60.0, 66.0]) {
      _line(
        c,
        [Offset(33, y), Offset(15, y - 3)],
        const Color(0xFF754B45),
        1.2,
      );
      _line(
        c,
        [Offset(67, y), Offset(85, y - 3)],
        const Color(0xFF754B45),
        1.2,
      );
    }
  }

  void _fish(Canvas c) {
    final tail = _polygon(const [
      Offset(70, 51),
      Offset(90, 29),
      Offset(88, 72),
    ]);
    _shade(
      c,
      tail,
      const Rect.fromLTWH(70, 29, 20, 43),
      const Color(0xFFFFC472),
      const Color(0xFFE96D62),
      shadow: true,
    );
    _shade(
      c,
      _polygon(const [Offset(43, 35), Offset(53, 19), Offset(61, 36)]),
      const Rect.fromLTWH(43, 19, 18, 17),
      const Color(0xFFFFC276),
      const Color(0xFFED8067),
    );
    _shade(
      c,
      _oval(46, 52, 31, 22),
      const Rect.fromLTWH(15, 30, 62, 44),
      const Color(0xFFFFE493),
      const Color(0xFFEF8B65),
      shadow: true,
    );
    _glint(c, 34, 39, 15, 4);
    _eye(c, 32, 47, r: 3);
    _line(c, const [
      Offset(22, 61),
      Offset(32, 64),
      Offset(40, 61),
    ], const Color(0xFFB96754));
    for (final x in [49.0, 60.0]) {
      _line(
        c,
        [Offset(x, 47), Offset(x + 4, 52), Offset(x, 57)],
        const Color(0x99CC745C),
        1.1,
      );
    }
    for (final spot in [const Offset(80, 21), const Offset(88, 15)]) {
      _shade(
        c,
        _oval(spot.dx, spot.dy, 4, 4),
        Rect.fromCircle(center: spot, radius: 4),
        const Color(0xFFE9FAFF),
        const Color(0xFF8DC9E5),
        outline: const Color(0x448DC9E5),
      );
      _glint(c, spot.dx - 1, spot.dy - 1, 1, 1);
    }
  }

  void _butterfly(Canvas c) {
    final leftTop = Path()
      ..moveTo(48, 46)
      ..cubicTo(22, 1, 10, 17, 18, 42)
      ..cubicTo(25, 61, 42, 55, 48, 46)
      ..close();
    final rightTop = Path()
      ..moveTo(52, 46)
      ..cubicTo(78, 1, 90, 17, 82, 42)
      ..cubicTo(75, 61, 58, 55, 52, 46)
      ..close();
    final leftBottom = Path()
      ..moveTo(47, 51)
      ..cubicTo(22, 43, 18, 65, 33, 76)
      ..cubicTo(47, 83, 49, 63, 47, 51)
      ..close();
    final rightBottom = Path()
      ..moveTo(53, 51)
      ..cubicTo(78, 43, 82, 65, 67, 76)
      ..cubicTo(53, 83, 51, 63, 53, 51)
      ..close();
    _shade(
      c,
      leftTop,
      const Rect.fromLTWH(15, 14, 34, 45),
      const Color(0xFFFFB3DC),
      const Color(0xFFDB69B2),
      shadow: true,
    );
    _shade(
      c,
      rightTop,
      const Rect.fromLTWH(51, 14, 34, 45),
      const Color(0xFFFFB3DC),
      const Color(0xFFDB69B2),
      shadow: true,
    );
    _shade(
      c,
      leftBottom,
      const Rect.fromLTWH(20, 47, 30, 31),
      const Color(0xFFFFE2A0),
      const Color(0xFFEAA960),
      shadow: true,
    );
    _shade(
      c,
      rightBottom,
      const Rect.fromLTWH(50, 47, 30, 31),
      const Color(0xFFFFE2A0),
      const Color(0xFFEAA960),
      shadow: true,
    );
    for (final x in [31.0, 69.0]) {
      _glint(c, x, 34, 7, 9);
      _shade(
        c,
        _oval(x, 64, 4, 4),
        Rect.fromLTWH(x - 4, 60, 8, 8),
        const Color(0xFFFFF7E9),
        const Color(0xFFFFC269),
        outline: Colors.transparent,
      );
    }
    _shade(
      c,
      _oval(50, 51, 6, 27),
      const Rect.fromLTWH(44, 24, 12, 54),
      const Color(0xFF8361A0),
      const Color(0xFF473B6A),
      shadow: true,
    );
    _line(c, const [Offset(48, 29), Offset(41, 16)], const Color(0xFF473B6A));
    _line(c, const [Offset(52, 29), Offset(59, 16)], const Color(0xFF473B6A));
    _eye(c, 48, 34, r: 1.3);
    _eye(c, 52, 34, r: 1.3);
  }

  void _turtle(Canvas c) {
    _shade(
      c,
      _oval(30, 72, 10, 8),
      const Rect.fromLTWH(20, 64, 20, 16),
      const Color(0xFFB7DC8C),
      const Color(0xFF6AAB69),
    );
    _shade(
      c,
      _oval(66, 72, 10, 8),
      const Rect.fromLTWH(56, 64, 20, 16),
      const Color(0xFFB7DC8C),
      const Color(0xFF6AAB69),
    );
    _shade(
      c,
      _oval(78, 50, 13, 12),
      const Rect.fromLTWH(65, 38, 26, 24),
      const Color(0xFFCCE99B),
      const Color(0xFF72B66A),
      shadow: true,
    );
    _shade(
      c,
      _oval(47, 60, 30, 17),
      const Rect.fromLTWH(17, 43, 60, 34),
      const Color(0xFFAFD781),
      const Color(0xFF5B9E64),
      shadow: true,
    );
    _shade(
      c,
      _oval(47, 48, 30, 22),
      const Rect.fromLTWH(17, 26, 60, 44),
      const Color(0xFFA7D175),
      const Color(0xFF47875A),
      shadow: true,
    );
    _glint(c, 35, 35, 13, 4);
    _line(
      c,
      const [Offset(28, 48), Offset(47, 35), Offset(67, 48)],
      const Color(0x88517B50),
      1.3,
    );
    _line(
      c,
      const [Offset(47, 35), Offset(47, 66)],
      const Color(0x88517B50),
      1.3,
    );
    _eye(c, 83, 47, r: 2);
    _line(c, const [Offset(80, 56), Offset(85, 57)], const Color(0xFF4B805A));
  }

  void _bird(Canvas c) {
    _shade(
      c,
      _polygon(const [Offset(21, 55), Offset(8, 39), Offset(13, 72)]),
      const Rect.fromLTWH(8, 39, 15, 33),
      const Color(0xFF9DD5EC),
      const Color(0xFF4C96C2),
    );
    _shade(
      c,
      _oval(46, 56, 29, 23),
      const Rect.fromLTWH(17, 33, 58, 46),
      const Color(0xFFC4E9F2),
      const Color(0xFF6EADCF),
      shadow: true,
    );
    _shade(
      c,
      _oval(61, 36, 16, 15),
      const Rect.fromLTWH(45, 21, 32, 30),
      const Color(0xFFD5F0F3),
      const Color(0xFF77BBD6),
      shadow: true,
    );
    _shade(
      c,
      _oval(43, 58, 18, 12),
      const Rect.fromLTWH(25, 46, 36, 24),
      const Color(0xFFA8D8EB),
      const Color(0xFF4C91BE),
    );
    _glint(c, 35, 43, 11, 4);
    _shade(
      c,
      _polygon(const [Offset(75, 36), Offset(91, 42), Offset(75, 47)]),
      const Rect.fromLTWH(75, 36, 16, 11),
      const Color(0xFFFFD974),
      const Color(0xFFE99B45),
    );
    _eye(c, 65, 34, r: 2.6);
    _line(
      c,
      const [Offset(38, 78), Offset(37, 87)],
      const Color(0xFFB98350),
      2.2,
    );
    _line(
      c,
      const [Offset(56, 78), Offset(57, 87)],
      const Color(0xFFB98350),
      2.2,
    );
  }

  @override
  bool shouldRepaint(covariant AnimalArtPainter oldDelegate) =>
      oldDelegate.id != id;
}
