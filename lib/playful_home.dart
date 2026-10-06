import 'dart:math' as math;

import 'package:flutter/material.dart';

class PlayfulWelcome extends StatefulWidget {
  const PlayfulWelcome({
    super.key,
    required this.completed,
    required this.total,
  });
  final int completed;
  final int total;

  @override
  State<PlayfulWelcome> createState() => _PlayfulWelcomeState();
}

class _PlayfulWelcomeState extends State<PlayfulWelcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  int _greeting = 0;
  static const _greetings = [
    'Hello, little artist!',
    'Wiggle your drawing fingers!',
    'Oops! My pencil is ticklish!',
    'Let’s make something silly!',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context)) _bounce.forward();
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  void _hello() {
    setState(() => _greeting = (_greeting + 1) % _greetings.length);
    if (!MediaQuery.disableAnimationsOf(context)) _bounce.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEDE5FF), Color(0xFFFFF0DE)],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white, width: 3),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LET’S PLAY & DRAW',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7459D9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Big ideas,\nlittle scribbles!',
                    style: TextStyle(
                      fontSize: 27,
                      height: 1.12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF26314D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _greetings[_greeting],
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.3,
                      color: Color(0xFF596584),
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: 'Say hello to the happy pencil',
              child: GestureDetector(
                onTap: _hello,
                child: AnimatedBuilder(
                  animation: _bounce,
                  builder: (context, child) {
                    final wave =
                        math.sin(_bounce.value * math.pi * 4) *
                        (1 - _bounce.value);
                    return Transform.translate(
                      offset: Offset(0, -wave.abs() * 12),
                      child: Transform.rotate(angle: wave * .16, child: child),
                    );
                  },
                  child: const SizedBox(
                    width: 92,
                    height: 130,
                    child: CustomPaint(painter: _HappyPencil()),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Tap me! ✨',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7459D9),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFEFA735),
                size: 27,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.completed} of ${widget.total} lessons finished',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF596584),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _HappyPencil extends CustomPainter {
  const _HappyPencil();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 92, size.height / 130);
    final paint = Paint();
    canvas.drawOval(
      const Rect.fromLTWH(16, 114, 62, 9),
      paint..color = const Color(0xFFDCD1F3),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(23, 12, 48, 82),
        const Radius.circular(13),
      ),
      paint..color = const Color(0xFFFFC65C),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(23, 12, 48, 24),
        const Radius.circular(11),
      ),
      paint..color = const Color(0xFFF28EAE),
    );
    canvas.drawRect(
      const Rect.fromLTWH(23, 31, 48, 9),
      paint..color = const Color(0xFF9E8CDB),
    );
    canvas.drawRect(
      const Rect.fromLTWH(28, 40, 7, 48),
      paint..color = const Color(0xFFFFDF89),
    );
    canvas.drawPath(
      Path()
        ..moveTo(23, 92)
        ..lineTo(71, 92)
        ..lineTo(47, 119)
        ..close(),
      paint..color = const Color(0xFFF2CEA6),
    );
    canvas.drawPath(
      Path()
        ..moveTo(39, 110)
        ..lineTo(55, 110)
        ..lineTo(47, 119)
        ..close(),
      paint..color = const Color(0xFF45405F),
    );
    paint.color = const Color(0xFF45405F);
    canvas.drawCircle(const Offset(38, 59), 3, paint);
    canvas.drawCircle(const Offset(57, 59), 3, paint);
    canvas.drawArc(
      const Rect.fromLTWH(38, 64, 19, 13),
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF45405F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      const Offset(30, 68),
      4,
      paint..color = const Color(0xFFF29A87),
    );
    canvas.drawCircle(const Offset(65, 68), 4, paint);
    for (final point in [const Offset(10, 38), const Offset(82, 82)]) {
      canvas.drawCircle(point, 4, paint..color = const Color(0xFF9B80E6));
    }
  }

  @override
  bool shouldRepaint(_HappyPencil oldDelegate) => false;
}

class BouncyCategoryIcon extends StatelessWidget {
  const BouncyCategoryIcon({
    super.key,
    required this.icon,
    required this.color,
  });
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: Duration(
      milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 650,
    ),
    curve: Curves.elasticOut,
    builder: (_, value, child) =>
        Transform.scale(scale: .65 + .35 * value, child: child),
    child: Icon(icon, size: 39, color: color),
  );
}
