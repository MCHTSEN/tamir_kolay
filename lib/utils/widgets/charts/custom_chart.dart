import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomChart extends ConsumerStatefulWidget {
  final String title;
  final String value;
  final double height;
  final Color? color;
  const CustomChart(
      {required this.height,
      super.key,
      this.color,
      required this.title,
      required this.value});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomChartState();
}

class _CustomChartState extends ConsumerState<CustomChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 37.h, end: widget.height).animate(_controller);
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
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: SizedBox(
            width: 25.w,
            child: Column(
              children: [
                Text(
                  widget.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[200]),
                ),
                Gap(1.h),
                Container(
                  width: 12.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color:
                        widget.color ?? Theme.of(context).colorScheme.tertiary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
