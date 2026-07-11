import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: borderColor,
            width: 1.5.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 26.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}