import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class CustomFleetStatusCard extends StatelessWidget {
  CustomFleetStatusCard({
    super.key,
    required this.totalFleetTitle,
    required this.totalFleetValue,
    required this.activeNowTitle,
    required this.activeNowValue,
    required this.excellenceText,
    this.width,
    EdgeInsetsGeometry? padding,
    this.borderColor = AppColor.fleetCardBorder,
    this.backgroundColor = Colors.white,
    this.showBorder = true,
  }) : padding = padding ?? EdgeInsets.fromLTRB(30.w, 28.h, 30.w, 28.h);

  final String totalFleetTitle;
  final String totalFleetValue;
  final String activeNowTitle;
  final String activeNowValue;
  final String excellenceText;

  final double? width;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color backgroundColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _FleetInfoItem(
                title: totalFleetTitle,
                value: totalFleetValue,
              ),
              SizedBox(width: 54.w),
              _FleetInfoItem(
                title: activeNowTitle,
                value: activeNowValue,
              ),
            ],
          ),

          SizedBox(height: 44.h),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: AppColor.excellenceBg,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: AppColor.excellenceDot,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 14.w),
                Text(
                  excellenceText,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    height: 1.2,
                    color: AppColor.excellenceText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FleetInfoItem extends StatelessWidget {
  _FleetInfoItem({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            height: 1.2,
            letterSpacing: 1.3,
            color: AppColor.fleetLabel,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 24.sp,
            height: 1.1,
            color: AppColor.fleetValue,
          ),
        ),
      ],
    );
  }
}