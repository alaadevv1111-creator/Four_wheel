import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final IconData? icon;
  final List<Color>? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
    this.icon,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 56.h,
        decoration: BoxDecoration(
          color: gradient == null ? (backgroundColor ?? AppColor.buttonColor) : null,
          gradient: gradient != null ? LinearGradient(
            colors: gradient!,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ) : null,
          borderRadius: BorderRadius.circular((borderRadius ?? 28).r),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: [
            if (gradient != null || backgroundColor != null)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white, size: 20.sp),
              SizedBox(width: 10.w),
            ],
            Text(
              text,
              style: GoogleFonts.manrope(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
