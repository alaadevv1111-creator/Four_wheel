import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceOrderNoticeCard extends StatelessWidget {
  const ServiceOrderNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xffEAF2FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          left: BorderSide(
            color: const Color(0xff52617A),
            width: 4.w,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xff52617A),
            size: 24.sp,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'Requests can only be cancelled within 12 hours of submission.',
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: const Color(0xff52617A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}