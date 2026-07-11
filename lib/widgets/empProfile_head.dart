import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeProfileHeader extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final String employeeId;
  final double rating;

  const EmployeeProfileHeader({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
    required this.employeeId,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: _buildImage(),
              ),
            ),

            Positioned(
              bottom: -18.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 22.sp,
                      color: const Color(0xffF9A800),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff191C1E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 34.h),

        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 34.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          '$role • ID: $employeeId',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff45464D),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (imagePath.isEmpty) {
      return _placeholder();
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 150.w,
        height: 150.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.file(
      File(imagePath),
      width: 150.w,
      height: 150.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 150.w,
      height: 150.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.person,
        size: 60.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}