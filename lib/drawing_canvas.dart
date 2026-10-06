import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'app_state.dart';
import 'lessons.dart';

const inkColors = [
  Color(0xFF7459D9),
  Color(0xFFED8E45),
  Color(0xFF2EAD98),
  Color(0xFFEC668E),
  Color(0xFF3D85CF),
  Color(0xFF344054),
];

Path _makePath(List<Offset> points, Size size) {
  final path = Path();
  if (points.isEmpty) return path;
  path.moveTo(points.first.dx * size.width, points.first.dy * size.height);
  for (final point in points.skip(1)) {
    path.lineTo(point.dx * size.width, point.dy * size.height);
  }
  return path;
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({
    this.lesson,
    this.completedGuideStrokes = 0,
    this.activeGuideStroke = 0,
    this.demoFraction,
    this.ink = const [],
    this.current = const [],
    this.currentColor = const Color(0xFF7459D9),
  });

  final LessonData? lesson;
  final int completedGuideStrokes;
  final int activeGuideStroke;
  final double? demoFraction;
  final List<InkStroke> ink;
  final List<Offset> current;
  final Color currentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = const Color(0xFFF2F5F9);
    for (double x = 24; x < size.width; x += 24) {
      for (double y = 24; y < size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), 1.2, grid);
      }
    }

    if (lesson != null) {
      final guide = lesson!;
      for (var i = 0; i < guide.strokes.length; i++) {
        final path = _makePath(guide.strokes[i], size);
        final base = Paint()
          ..color = const Color(0xFFE3E9F1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(10, size.width * 0.029)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(path, base);

        if (demoFraction != null) {
          final global = demoFraction! * guide.strokes.length;
          final part = (global - i).clamp(0.0, 1.0);
          if (part > 0) {
            final metric = path.computeMetrics().firstOrNull;
            if (metric != null) {
              canvas.drawPath(
                metric.extractPath(0, metric.length * part),
                base..color = guide.color,
              );
            }
          }
        } else if (i < completedGuideStrokes) {
          canvas.drawPath(path, base..color = guide.color);
        }
      }
      if (demoFraction == null && activeGuideStroke < guide.strokes.length) {
        final start = guide.strokes[activeGuideStroke].first;
        final spot = Offset(start.dx * size.width, start.dy * size.height);
        canvas.drawCircle(spot, 13, Paint()..color = guide.color);
        canvas.drawCircle(spot, 5, Paint()..color = Colors.white);
      }
    }

    for (final stroke in ink) {
      _paintInk(canvas, size, stroke.points, stroke.color);
    }
    _paintInk(canvas, size, current, currentColor);
  }

  void _paintInk(Canvas canvas, Size size, List<Offset> points, Color color) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(7, size.width * 0.019)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (points.length == 1) {
      canvas.drawCircle(
        Offset(points.first.dx * size.width, points.first.dy * size.height),
        paint.strokeWidth / 2,
        Paint()..color = color,
      );
    } else {
      canvas.drawPath(_makePath(points, size), paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}

class LessonPreviewPainter extends CustomPainter {
  const LessonPreviewPainter(this.lesson);
  final LessonData lesson;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lesson.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.5, size.width * .045)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final stroke in lesson.strokes) {
      canvas.drawPath(_makePath(stroke, size), paint);
    }
  }

  @override
  bool shouldRepaint(covariant LessonPreviewPainter oldDelegate) =>
      oldDelegate.lesson != lesson;
}

class DrawingBoardFrame extends StatelessWidget {
  const DrawingBoardFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE4E9F2), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x150C2142),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    ),
  );
}

/// Claims drawing gestures before an enclosing scroll view can move the canvas.
class _DrawingInput extends StatelessWidget {
  const _DrawingInput({
    required this.child,
    required this.onDown,
    required this.onMove,
    required this.onUp,
    required this.onCancel,
  });

  final Widget child;
  final ValueChanged<PointerDownEvent> onDown;
  final ValueChanged<PointerMoveEvent> onMove;
  final ValueChanged<PointerUpEvent> onUp;
  final ValueChanged<PointerCancelEvent> onCancel;

  @override
  Widget build(BuildContext context) => RawGestureDetector(
    gestures: {
      EagerGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<EagerGestureRecognizer>(
            () => EagerGestureRecognizer(),
            (_) {},
          ),
    },
    child: Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: onDown,
      onPointerMove: onMove,
      onPointerUp: onUp,
      onPointerCancel: onCancel,
      child: child,
    ),
  );
}

class TracingBoard extends StatefulWidget {
  const TracingBoard({
    super.key,
    required this.lesson,
    required this.onComplete,
    required this.onStrokeDone,
  });
  final LessonData lesson;
  final VoidCallback onComplete;
  final ValueChanged<int> onStrokeDone;

  @override
  State<TracingBoard> createState() => _TracingBoardState();
}

class _TracingBoardState extends State<TracingBoard> {
  int completed = 0;
  List<Offset> current = [];
  bool drawing = false;

  Offset _point(Offset local, Size size) => Offset(
    (local.dx / size.width).clamp(0, 1),
    (local.dy / size.height).clamp(0, 1),
  );

  double _distance(Offset a, Offset b) => (a - b).distance;

  bool _coversGuide(List<Offset> target, List<Offset> drawn) {
    if (drawn.length < 4) return false;
    double drawnLength = 0;
    for (var i = 1; i < drawn.length; i++) {
      drawnLength += _distance(drawn[i - 1], drawn[i]);
    }
    double targetLength = 0;
    for (var i = 1; i < target.length; i++) {
      targetLength += _distance(target[i - 1], target[i]);
    }
    if (drawnLength < targetLength * .45) return false;
    var near = 0;
    var samples = 0;
    for (var i = 1; i < target.length; i++) {
      final a = target[i - 1];
      final b = target[i];
      final count = math.max(2, ((b - a).distance / .025).ceil());
      for (var j = 0; j <= count; j++) {
        final sample = Offset.lerp(a, b, j / count)!;
        samples++;
        if (drawn.any((p) => _distance(sample, p) < .105)) near++;
      }
    }
    return samples > 0 && near / samples >= .56;
  }

  @override
  Widget build(BuildContext context) {
    return DrawingBoardFrame(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return _DrawingInput(
            onDown: (event) {
              if (completed >= widget.lesson.strokes.length) return;
              final point = _point(event.localPosition, size);
              final start = widget.lesson.strokes[completed].first;
              if (_distance(point, start) > .20) return;
              setState(() {
                drawing = true;
                current = [point];
              });
            },
            onMove: (event) {
              if (!drawing) return;
              setState(() => current.add(_point(event.localPosition, size)));
            },
            onUp: (_) {
              if (!drawing) return;
              final correct = _coversGuide(
                widget.lesson.strokes[completed],
                current,
              );
              setState(() {
                drawing = false;
                current = [];
                if (correct) completed++;
              });
              if (correct) {
                widget.onStrokeDone(completed);
                if (completed == widget.lesson.strokes.length) {
                  widget.onComplete();
                }
              }
            },
            onCancel: (_) => setState(() {
              drawing = false;
              current = [];
            }),
            child: CustomPaint(
              painter: DrawingPainter(
                lesson: widget.lesson,
                completedGuideStrokes: completed,
                activeGuideStroke: completed,
                current: current,
                currentColor: widget.lesson.color,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}

class FreeDrawingBoard extends StatefulWidget {
  const FreeDrawingBoard({
    super.key,
    required this.color,
    required this.strokes,
    required this.onChanged,
  });
  final Color color;
  final List<InkStroke> strokes;
  final ValueChanged<List<InkStroke>> onChanged;

  @override
  State<FreeDrawingBoard> createState() => _FreeDrawingBoardState();
}

class _FreeDrawingBoardState extends State<FreeDrawingBoard> {
  List<Offset> current = [];

  @override
  Widget build(BuildContext context) {
    return DrawingBoardFrame(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          Offset normalize(Offset p) => Offset(
            (p.dx / size.width).clamp(0, 1),
            (p.dy / size.height).clamp(0, 1),
          );
          return _DrawingInput(
            onDown: (event) =>
                setState(() => current = [normalize(event.localPosition)]),
            onMove: (event) =>
                setState(() => current.add(normalize(event.localPosition))),
            onUp: (_) {
              if (current.isNotEmpty) {
                widget.onChanged([
                  ...widget.strokes,
                  InkStroke(List.of(current), widget.color),
                ]);
              }
              setState(() => current = []);
            },
            onCancel: (_) => setState(() => current = []),
            child: CustomPaint(
              painter: DrawingPainter(
                ink: widget.strokes,
                current: current,
                currentColor: widget.color,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}
