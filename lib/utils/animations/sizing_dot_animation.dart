import 'package:flutter/material.dart';

class SizingDotAnimation extends StatefulWidget {
  const SizingDotAnimation({super.key});

  @override
  _BouncingDotAnimationState createState() => _BouncingDotAnimationState();
}

class _BouncingDotAnimationState extends State<SizingDotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(100, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
      ),
    );

    _sizeAnimation = Tween<double>(
      begin: 20,
      end: 100,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
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
        return Center(
          child: Transform.translate(
            offset: _offsetAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: _sizeAnimation.value,
              height: _sizeAnimation.value,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
        );
      },
    );
  }
}
