import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarDetailsTitleSection extends StatelessWidget {
  final String name;
  final String pricePerDay;
  final bool isAvailable;
  final String availabilityText;
  final double? rating;
  final int? reviewsCount;

  const CarDetailsTitleSection({
    super.key,
    required this.name,
    required this.pricePerDay,
    required this.isAvailable,
    required this.availabilityText,
    this.rating,
    this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 30.h, 28.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$$pricePerDay',
                      style: GoogleFonts.manrope(
                        fontSize: 27.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '/day',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff45464D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isAvailable
                  ? const Color(0xffDCFCE7)
                  : const Color(0xffE5E7EB),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Text(
              availabilityText,
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: isAvailable
                    ? const Color(0xff15803D)
                    : const Color(0xff64748B),
              ),
            ),
          ),

          if (rating != null && reviewsCount != null) ...[
            SizedBox(height: 22.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F0FF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 18.sp,
                        color: const Color(0xff64748B),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '$reviewsCount reviews',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff45464D),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}