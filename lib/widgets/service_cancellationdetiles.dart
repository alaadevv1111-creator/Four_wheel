import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCancellationDetailsCard extends StatelessWidget {
  const ServiceCancellationDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xffFCA5A5).withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Service Cancellation',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.timer_outlined,
                color: const Color(0xffDC2626),
                size: 25.sp,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            'Service requests may only be cancelled within 24 hours of placement.',
            style: GoogleFonts.manrope(
              fontSize: 15.sp,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: const Color(0xff45464D),
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xffFEF2F2),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Center(
              child: Text(
                '12 Hours Remaining',
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xffDC2626),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}