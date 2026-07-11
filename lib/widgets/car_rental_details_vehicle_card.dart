import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class CarRentalDetailsVehicleCard extends StatelessWidget {
  final String image;
  final String carName;
  final String rentalId;

  const CarRentalDetailsVehicleCard({
    super.key,
    required this.image,
    required this.carName,
    required this.rentalId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carName,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff52617A),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  rentalId,
                  style: GoogleFonts.manrope(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
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
    final path = image.trim();

    if (path.isEmpty || path == 'null') {
      return _placeholder();
    }

    if (ImageHelper.isLocalFile(path)) {
      return Image.file(
        File(path),
        width: double.infinity,
        height: 255.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.network(
      ImageHelper.resolveServerUrl(path),
      width: double.infinity,
      height: 255.h,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 255.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.directions_car_filled_outlined,
        size: 70.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}