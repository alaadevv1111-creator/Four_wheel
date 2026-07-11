import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Gradient? gradient;
  final Color foregroundColor;
  final double? width;
  final double? height;
  final double? radius;
  final double elevation;
  final bool isCircle;

  const CustomFloatingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.foregroundColor = Colors.white,
    this.width,
    this.height,
    this.radius,
    this.elevation = 4,
    this.isCircle = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ?? 56.w;
    final h = height ?? 56.h;
    final r = radius ?? 18.r;

    return FloatingActionButton(
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      backgroundColor: Colors.transparent,
      elevation: elevation,
      shape: isCircle
          ? const CircleBorder()
          : RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r),
      ),
      child: Container(
        width: w,
        height: h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(r),
          gradient: gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.cardprim,
                  AppColor.cardprim2,
                ],
              ),
        ),
        child: SizedBox(
          height: h,
          width: w,
          child: Center(child: child),
        ),
      ),
    );
  }
}