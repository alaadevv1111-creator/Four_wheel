import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceRequestStatusHeader extends StatelessWidget {
  final String requestNumber;
  final String status;

  const ServiceRequestStatusHeader({
    super.key,
    required this.requestNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'REQUEST #$requestNumber',
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              letterSpacing: 5,
              fontWeight: FontWeight.bold,
              color: const Color(0xff45464D),
            ),
          ),
        ),
        SizedBox(height: 28.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            borderRadius: BorderRadius.circular(36.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff334155).withOpacity(0.28),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 18.sp,
                color: Colors.white,
              ),
              SizedBox(width: 18.w),
              Text(
                status,
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}