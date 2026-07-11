import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarRentalLocationCard extends StatelessWidget {
  final String location;

  const CarRentalLocationCard({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xffE5E7EB),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.black,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOCATION',
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    letterSpacing: 2.3,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff52617A),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  location,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.map_outlined,
            color: const Color(0xff52617A),
            size: 28.sp,
          ),
        ],
      ),
    );
  }
}