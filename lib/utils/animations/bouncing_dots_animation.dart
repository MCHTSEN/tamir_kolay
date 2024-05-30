import 'package:flutter/material.dart';

class BouncingDotsAnimation extends StatefulWidget {
  const BouncingDotsAnimation({super.key});

  @override
  _BouncingDotsAnimationState createState() => _BouncingDotsAnimationState();
}

class _BouncingDotsAnimationState extends State<BouncingDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _animation1 = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, _animation1.value),
              child: const BouncingDot(),
            ),
            Transform.translate(
              offset: Offset(0, _animation2.value),
              child: const BouncingDot(),
            ),
            Transform.translate(
              offset: Offset(0, _animation3.value),
              child: const BouncingDot(),
            ),
          ],
        );
      },
    );
  }
}

class BouncingDot extends StatelessWidget {
  const BouncingDot({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.lightBlueAccent],
        ),
      ),
    );
  }
}
