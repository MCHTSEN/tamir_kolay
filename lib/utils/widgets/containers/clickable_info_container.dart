import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClickableInfoContainer extends StatelessWidget {
  const ClickableInfoContainer({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });
  final String title;
  final String value;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Gap(5.w),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Gap(5.w),
          ],
        ),
      ),
    );
  }
}
