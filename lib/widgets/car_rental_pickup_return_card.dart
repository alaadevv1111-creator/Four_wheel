import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarRentalPickupReturnCard extends StatelessWidget {
  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;

  const CarRentalPickupReturnCard({
    super.key,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 26.h, 24.w, 26.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('PICKUP & RETURN'),
          SizedBox(height: 22.h),
          _dateRow(
            icon: Icons.calendar_today_outlined,
            date: pickupDate,
            time: pickupTime,
          ),
          SizedBox(height: 22.h),
          _dateRow(
            icon: Icons.event_available_outlined,
            date: returnDate,
            time: returnTime,
          ),
        ],
      ),
    );
  }

  Widget _dateRow({
    required IconData icon,
    required String date,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xff52617A),
          size: 25.sp,
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff52617A),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 14.sp,
        letterSpacing: 2.3,
        fontWeight: FontWeight.w900,
        color: const Color(0xff52617A),
      ),
    );
  }
}