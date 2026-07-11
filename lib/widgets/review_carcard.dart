import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  final String image;
  final String badge;
  final String name;
  final String subtitle;
  final String pricePerDay;

  const ReviewCard({
    super.key,
    required this.image,
    required this.badge,
    required this.name,
    required this.subtitle,
    required this.pricePerDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: SizedBox(
              width: double.infinity,
              height: 150.h,
              child: _imageWidget(image),
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xffE8EEF8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              badge.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff667085),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff101828),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              color: const Color(0xff667085),
            ),
          ),
          SizedBox(height: 14.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '\$$pricePerDay',
                  style: GoogleFonts.manrope(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
                TextSpan(
                  text: ' / day',
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    color: const Color(0xff667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageWidget(String path) {
    final value = path.trim();

    if (value.isEmpty || value == 'null') {
      return _placeholder();
    }

    if (value.startsWith('http')) {
      return Image.network(
        value,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    if (value.startsWith('assets/')) {
      return Image.asset(
        value,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.file(
      File(value),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xffE5E7EB),
      child: Center(
        child: Icon(Icons.directions_car, size: 46.sp, color: Colors.grey),
      ),
    );
  }
}