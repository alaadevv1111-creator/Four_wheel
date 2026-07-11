import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RentalSummaryCard extends StatelessWidget {
  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;
  final int rentalDays;
  final int estimatedTotal;

  const RentalSummaryCard({
    super.key,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.rentalDays,
    required this.estimatedTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(28.w, 56.h, 28.w, 0),
      padding: EdgeInsets.fromLTRB(26.w, 26.h, 26.w, 26.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dateItem(
                  title: 'PICKUP DATE',
                  value: '$pickupDate, $pickupTime',
                ),
              ),
              Expanded(
                child: _dateItem(
                  title: 'RETURN DATE',
                  value: '$returnDate, $returnTime',
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),
          const Divider(color: Color(0xffE5E7EB)),
          SizedBox(height: 20.h),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 20,
                color: Colors.black,
              ),
              SizedBox(width: 12.w),
              Text(
                'Rental Duration',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff45464D),
                ),
              ),
              const Spacer(),
              Text(
                '$rentalDays Days',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          const Divider(color: Color(0xffE5E7EB)),
          SizedBox(height: 20.h),

          Row(
            children: [
              Text(
                'Estimated Total',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff45464D),
                ),
              ),
              const Spacer(),
              Text(
                '\$$estimatedTotal',
                style: GoogleFonts.manrope(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateItem({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 12.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w900,
            color: const Color(0xff45464D),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}