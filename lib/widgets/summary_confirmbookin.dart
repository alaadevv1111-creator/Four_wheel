import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/widgets/custom_button.dart';

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
      padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          _row(rentalText, rentalAmount),
          SizedBox(height: 18.h),
          _row('Additional Services', additionalServices),
          SizedBox(height: 18.h),
          _row('Taxes & Fees', taxes),
          SizedBox(height: 22.h),
          const Divider(color: Color(0xffD1D5DB)),
          SizedBox(height: 22.h),
          Row(
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff191C1E),
                ),
              ),
              const Spacer(),
              Text(
                totalAmount,
                style: GoogleFonts.manrope(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          CustomButton(
            text: 'Confirm Booking',
            textcolor: Colors.white,
            height: 64.h,
            color: const Color(0xff334155),
            icon: Icons.arrow_forward,
            fontwight: FontWeight.w900,
            fontsize: 18.sp,
            onTap: onConfirm,
          ),
          SizedBox(height: 22.h),
          Text(
            'SECURE CHECKOUT POWERED BY FOUR WHEELS FINANCIAL',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 10.sp,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
              color: const Color(0xff45464D),
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
              fontSize: 15.sp,
              color: const Color(0xff45464D),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff191C1E),
          ),
        ),
      ],
    );
  }
}