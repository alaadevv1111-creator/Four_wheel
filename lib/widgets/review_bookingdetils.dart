import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewBookingDetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String location;
  final String dateTime;

  const ReviewBookingDetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.location,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: const Color(0xff344054)),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: const Color(0xff344054),
                  ),
                ),
                if (location.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  Text(
                    location,
                    style: GoogleFonts.manrope(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff101828),
                    ),
                  ),
                ],
                if (dateTime.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    dateTime,
                    style: GoogleFonts.manrope(
                      fontSize: 13.sp,
                      color: const Color(0xff64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingAddonTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const BookingAddonTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xffF1F5F9),
              child: Icon(icon, color: const Color(0xff344054)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff101828),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      color: const Color(0xff667085),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingPaymentSummaryCard extends StatelessWidget {
  final String rentalText;
  final String rentalAmount;
  final String additionalServices;
  final String taxes;
  final String totalAmount;
  final VoidCallback onConfirm;

  const BookingPaymentSummaryCard({
    super.key,
    required this.rentalText,
    required this.rentalAmount,
    required this.additionalServices,
    required this.taxes,
    required this.totalAmount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          _row(rentalText, rentalAmount),
          SizedBox(height: 14.h),
          _row('Additional Services', additionalServices),
          SizedBox(height: 14.h),
          _row('Taxes & Fees', taxes),
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 18.h),
          Row(
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const Spacer(),
              Text(
                totalAmount,
                style: GoogleFonts.manrope(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
            ],
          ),
          SizedBox(height: 26.h),
          SizedBox(
            width: double.infinity,
            height: 58.h,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff344054),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                'Confirm Booking  →',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'SECURE CHECKOUT POWERED BY FOUR WHEELS',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 10.sp,
              letterSpacing: 1.4,
              color: const Color(0xff667085),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              color: const Color(0xff667085),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
      ],
    );
  }
}