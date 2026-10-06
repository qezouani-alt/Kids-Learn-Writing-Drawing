import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'branding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4700),
  )..forward();
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8FAFF),
    body: SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -100,
            child: _Glow(color: const Color(0xFFEDE6FF), diameter: 290),
          ),
          Positioned(
            bottom: -110,
            left: -120,
            child: _Glow(color: const Color(0xFFFFECE0), diameter: 310),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 88,
                        height: 88,
                        semanticLabel: 'Kids Learn app icon',
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      splashDisplayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF26314D),
                        fontSize: 34,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Big ideas begin with a little line.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF71809C), fontSize: 16),
                    ),
                    const SizedBox(height: 52),
                    Semantics(
                      label: 'Loading drawing lessons',
                      child: AnimatedBuilder(
                        animation: _progress,
                        builder: (context, _) => SizedBox(
                          width: double.infinity,
                          height: 82,
                          child: CustomPaint(
                            painter: _PenProgressPainter(_progress.value),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Getting your pencils ready…',
                      style: TextStyle(
                        color: Color(0xFF71809C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.diameter});

  final Color color;
  final double diameter;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

class _PenProgressPainter extends CustomPainter {
  const _PenProgressPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final start = 44.0;
    final end = math.max(start, size.width - 30);
    final tipX = start + (end - start) * progress;
    const lineY = 58.0;
    final track = RRect.fromRectAndRadius(
      Rect.fromLTRB(start, lineY - 5, end, lineY + 5),
      const Radius.circular(5),
    );
    canvas.drawRRect(track, Paint()..color = const Color(0xFFE3DDF8));
    if (tipX > start) {
      final stroke = RRect.fromRectAndRadius(
        Rect.fromLTRB(start, lineY - 5, tipX, lineY + 5),
        const Radius.circular(5),
      );
      canvas.drawRRect(
        stroke,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFA987F1), Color(0xFF6E52D3)],
          ).createShader(Rect.fromLTRB(start, lineY - 5, end, lineY + 5)),
      );
    }

    // The pencil tip follows the leading edge of the freshly drawn line.
    canvas.save();
    canvas.translate(tipX, lineY);
    canvas.rotate(-math.pi / 4);
    final nib = Path()
      ..moveTo(0, 0)
      ..lineTo(-7, -12)
      ..lineTo(7, -12)
      ..close();
    canvas.drawPath(nib, Paint()..color = const Color(0xFFFFC27A));
    canvas.drawCircle(
      Offset.zero,
      2.2,
      Paint()..color = const Color(0xFF26314D),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-7, -44, 14, 32),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF7459D9),
    );
    canvas.drawRect(
      const Rect.fromLTWH(-7, -18, 14, 4),
      Paint()..color = const Color(0xFF523BAC),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-7, -49, 14, 7),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFFA9BA),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PenProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
