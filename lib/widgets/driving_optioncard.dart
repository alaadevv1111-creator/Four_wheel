import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrivingOptionCard extends StatelessWidget {
  final bool hasLicense;
  final String licenseFileName;
  final String? driverName;
  final String? driverExperience;

  const DrivingOptionCard({
    super.key,
    required this.hasLicense,
    required this.licenseFileName,
    this.driverName,
    this.driverExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 22.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 54.w,
            height: 54.h,
            decoration: BoxDecoration(
              color: const Color(0xffF1F2F4),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              hasLicense
                  ? Icons.badge_outlined
                  : Icons.person_pin_circle_outlined,
              color: const Color(0xff334155),
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: hasLicense
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driving License Uploaded',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff191C1E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  licenseFileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName ?? 'Selected Driver',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff191C1E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  driverExperience ?? 'Professional driver selected',
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    color: const Color(0xff64748B),
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