import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class CarSpecTile extends StatelessWidget {
  const CarSpecTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final String icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(icon,
            width: 18.w,
            height: 18.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.titleBlack,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleBlack,
            ),
          ),
        ],
      ),
    );
  }
}