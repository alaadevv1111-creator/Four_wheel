import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MechanicCarIssueCard extends StatelessWidget {
  final String carName;
  final String carImage;
  final String plateNumber;
  final String vin;
  final String status;
  final String reportedIssue;

  const MechanicCarIssueCard({
    super.key,
    required this.carName,
    required this.carImage,
    required this.plateNumber,
    required this.vin,
    required this.status,
    required this.reportedIssue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _buildCarImage(),
              Positioned(
                top: 18.h,
                right: 18.w,
                child: _statusBadge(),
              ),
              Positioned(
                left: 22.w,
                right: 22.w,
                bottom: 22.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vin.isEmpty ? 'Plate: $plateNumber' : 'VIN: $vin',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFEF2F2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: const Color(0xffDC2626),
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Text(
                      'Reported Issue',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff191C1E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F5F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    reportedIssue,
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xffE5E7EB),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        status,
        style: GoogleFonts.manrope(
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xff45464D),
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    if (carImage.startsWith('http')) {
      return Image.network(
        carImage,
        width: double.infinity,
        height: 280.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (carImage.isNotEmpty) {
      return Image.file(
        File(carImage),
        width: double.infinity,
        height: 280.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 280.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.directions_car_filled_outlined,
        size: 60.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}