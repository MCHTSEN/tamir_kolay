import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BasicInfoCard extends StatelessWidget {
  final String text;
  final String text2;
  final double width;
  final IconData? icon;
  const BasicInfoCard({
    super.key,
    required this.text,
    required this.width,
    required this.text2,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: width,
              height: 11.h,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500]!),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      indent: 12,
                      endIndent: 12,
                    ),
                    Text(text2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ],
                ),
              ),
            ),
            Gap(2.h),
          ],
        ),
        if (icon != null)
          Positioned(
            bottom: 0.5.h,
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
