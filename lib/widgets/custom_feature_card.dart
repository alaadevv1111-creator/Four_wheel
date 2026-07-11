import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CustomFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 163.w,
      height: 127.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.cardBg, // FEFDFA
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة اللوجو (أسود)
          Icon(
            icon,
            color: Colors.black,
            size: 28.r,
          ),
          SizedBox(height: 12.h),
          // العنوان (191C1E, 16, Bold)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary, // 191C1E
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          // الوصف السفلي (45464D, 10, Regular)
          Flexible(
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400, // Regular
                color: AppColor.bcolorsmalltitle, // 45464D
              ),
            ),
          ),
        ],
      ),
    );
  }
}
