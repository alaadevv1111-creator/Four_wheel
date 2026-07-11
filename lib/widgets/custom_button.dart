import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? textcolor;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? color;
  final Gradient? gradient;
  final FontWeight? fontwight;
  final double? fontsize;

  const CustomButton({
    required this.textcolor,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
    this.icon,
    this.color,
    this.gradient,
    this.fontwight,
    this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: gradient == null ? (color ?? AppColor.primary) : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(48.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text ?? "",
              style: GoogleFonts.manrope(
                color: textcolor ?? Colors.white,
                fontWeight: fontwight,
                fontSize: fontsize,
              ),
            ),
            SizedBox(width: 10.w),
            if (icon != null) ...[
              SizedBox(width: 10.w),
              Icon(icon, color: Colors.white, size: 18.sp),
            ],
          ],
        ),
      ),
    );
  }
}