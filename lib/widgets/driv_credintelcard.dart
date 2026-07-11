import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverCredentialsCard extends StatelessWidget {
  final String licenseImage;
  final String licenseNumber;
  final String validUntil;

  const DriverCredentialsCard({
    super.key,
    required this.licenseImage,
    required this.licenseNumber,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28.w, 24.h, 28.w, 24.h),
            color: const Color(0xffF1F2F4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Driving Credentials',
                    style: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff191C1E),
                    ),
                  ),
                ),
                Icon(
                  Icons.verified_user_rounded,
                  color: const Color(0xffBAC5E4),
                  size: 30.sp,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 28.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _buildImage(),
                ),

                SizedBox(width: 26.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LICENSE NUMBER',
                        style: GoogleFonts.manrope(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: const Color(0xff45464D),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        licenseNumber,
                        style: GoogleFonts.manrope(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffEEF0F3),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Valid until $validUntil',
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffDCEBFF),
                          ),
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

  Widget _buildImage() {
    if (licenseImage.isEmpty) {
      return _placeholder();
    }

    if (licenseImage.startsWith('http')) {
      return Image.network(
        licenseImage,
        width: 145.w,
        height: 95.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (licenseImage.startsWith('assets/')) {
      return Image.asset(
        licenseImage,
        width: 145.w,
        height: 95.h,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(licenseImage),
      width: 145.w,
      height: 95.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 145.w,
      height: 95.h,
      color: const Color(0xffD1D5DB),
      child: Icon(
        Icons.credit_card,
        color: const Color(0xff6B7280),
      ),
    );
  }
}