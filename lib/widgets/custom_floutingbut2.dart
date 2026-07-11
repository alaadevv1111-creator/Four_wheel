import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class CustomFloatingButton2 extends StatelessWidget {
  final VoidCallback onTab;
  final Widget? child;
  final double? width;
  final double? height;
  final double? radius;

  CustomFloatingButton2({
    super.key,
    required this.onTab,
    required this.child,
    this.width,
    this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: width ?? 162.w,
        height: height ?? 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((radius ?? 18).r),
          gradient: AppColor.primaryGradient,
        ),
        child: child,
      ),
    );
  }
}