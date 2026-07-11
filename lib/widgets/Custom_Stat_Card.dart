import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color iconBgColor;
  final Color iconColor;
  final Color valueColor;
  final Color titleColor;
  final Color? subtitleColor;
  final double borderRadius;

  const CustomStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.backgroundColor,
    this.gradient,
    required this.iconBgColor,
    required this.iconColor,
    required this.valueColor,
    required this.titleColor,
    this.subtitleColor,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Colors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
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
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0.h),
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    letterSpacing: 1.2.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14.sp,
                color: subtitleColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
