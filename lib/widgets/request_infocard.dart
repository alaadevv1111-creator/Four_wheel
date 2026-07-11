import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestInfoCard extends StatelessWidget {
  const RequestInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28.w, 24.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: const Color(0xffDCEBFF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.info,
              color: const Color(0xff52617A),
              size: 30.sp,
            ),
          ),
          SizedBox(width: 22.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Response time: within 12 hours',
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff191C1E),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Requests can be cancelled within 12 hours after submission without any penalty.',
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    height: 1.5,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff45464D),
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