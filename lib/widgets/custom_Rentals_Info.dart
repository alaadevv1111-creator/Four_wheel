import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String footerText;
  final IconData icon;
  final double? borderRadius;
  final Color? iconColor;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? titleColor;
  final Color? valueColor;
  final Color? footerColor;

  const CustomInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.footerText,
    required this.icon,
    this.borderRadius,
    this.iconColor,
    this.backgroundColor,
    this.gradient,
    this.titleColor,
    this.valueColor,
    this.footerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Colors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular((borderRadius ?? 16.0).r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: titleColor ?? const Color(0xFF515F74),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                icon,
                color: iconColor ?? const Color(0xFF191C1E),
                size: 24.sp,
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Text(
            value,
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF191C1E),
              letterSpacing: -1,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            footerText,
            style: TextStyle(
              fontSize: 14.sp,
              color: footerColor ?? const Color(0xFF45464D),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}