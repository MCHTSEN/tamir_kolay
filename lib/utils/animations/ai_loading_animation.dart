import 'dart:math';

import 'package:flutter/material.dart';

class AILoadingAnimation extends StatefulWidget {
  @override
  _AILoadingAnimationState createState() => _AILoadingAnimationState();
}

class _AILoadingAnimationState extends State<AILoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AILoadingPainter(animation: _controller),
      child: SizedBox(
        width: 100,
        height: 100,
      ),
    );
  }
}

class _AILoadingPainter extends CustomPainter {
  _AILoadingPainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double radius = size.width / 10;
    final double angle = 2 * pi * animation.value;

    final List<Color> colors = [
      Color(0xFF4F2E6F), // Purple
      Color(0xFFFF4F81), // Pink
      Color(0xFF00BFFF), // Sky Blue
      Color(0xFF32CD32), // Lime Green
    ];

    for (int i = 0; i < 4; i++) {
      final double x = size.width / 2 + (size.width / 3) * cos(angle + (pi / 2) * i);
      final double y = size.height / 2 + (size.height / 3) * sin(angle + (pi / 2) * i);

      paint.color = colors[i];
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}