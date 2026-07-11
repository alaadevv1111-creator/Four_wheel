import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class FleetSupportCard extends StatelessWidget {
  final String label;
  final String title;
  final String activeToday;
  final String onStandby;

  const FleetSupportCard({
    super.key,
    this.label = "ACTIVE FLEET SUPPORT",
    this.title = "Workforce\noverview at\na glance,\nupdated\nlive.",
    required this.activeToday,
    required this.onStandby,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 410.h,
                padding: EdgeInsets.fromLTRB(28.w, 36.h, 28.w, 28.h),
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.r), bottomLeft: Radius.circular(20.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        letterSpacing: 3,
                        color: Colors.white38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 40.sp,
                        height: 1.12,
                        color: Colors.white.withOpacity(0.88),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeToday,
                              style: GoogleFonts.manrope(
                                fontSize: 26.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "ACTIVE TODAY",
                              style: GoogleFonts.manrope(
                                fontSize: 11.sp,
                                color: Colors.white60,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 70.w),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              onStandby,
                              style: GoogleFonts.manrope(
                                fontSize: 26.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "ON STANDBY",
                              style: GoogleFonts.manrope(
                                fontSize: 11.sp,
                                color: Colors.white60,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 226.h,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 36.h),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffE8F8F0),
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        color: const Color(0xff35C28A),
                        size: 25.sp,
                      ),
                    ),

                    SizedBox(height: 22.h),

                    Text(
                      "Safety Certified",
                      style: GoogleFonts.manrope(
                        fontSize: 25.sp,
                        color: const Color(0xff334155),
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "All staff have completed the quarterly\nsafety protocols.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        height: 1.35,
                        color: const Color(0xff9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}