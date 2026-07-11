import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceOverviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;

  const ServiceOverviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff191C1E),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              height: 1.35,
              fontWeight: FontWeight.normal,
              color: const Color(0xff45464D),
            ),
          ),
          SizedBox(height: 34.h),
          Row(
            children: [
              Expanded(
                child: _smallInfoBox(
                  icon: Icons.calendar_today_outlined,
                  label: 'DATE',
                  value: date,
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: _smallInfoBox(
                  icon: Icons.access_time_outlined,
                  label: 'TIME',
                  value: time,
                ),
              ),
            ],
          ),
          SizedBox(height: 26.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 18.h),
            decoration: BoxDecoration(
              color: const Color(0xffF1F2F4),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffE5E7EB),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 20.sp,
                    color: const Color(0xff52617A),
                  ),
                ),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SERVICE LOCATION',
                        style: GoogleFonts.manrope(
                          fontSize: 10.sp,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff45464D),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff191C1E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallInfoBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      height: 90.h,
      width: 200.w,
      padding: EdgeInsets.fromLTRB(22.w, 20.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: const Color(0xffF1F2F4),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: const Color(0xff52617A),
              ),
              SizedBox(width: 10.w),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff45464D),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff191C1E),
            ),
          ),
        ],
      ),
    );
  }
}