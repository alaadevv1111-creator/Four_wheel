import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccessoryPaymentDetailsCard extends StatelessWidget {
  final String method;
  final String status;

  const AccessoryPaymentDetailsCard({
    super.key,
    required this.method,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border(
          left: BorderSide(
            color: const Color(0xff52617A),
            width: 4.w,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: const Color(0xff52617A),
                size: 25.sp,
              ),
              SizedBox(width: 14.w),
              Text(
                'Payment Details',
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _row('Method', method),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                'Status',
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff45464D),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF2F7),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff52617A),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: const Color(0xffEEF0F3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xff52617A),
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Payment is collected upon delivery.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 15.sp,
                      height: 1.5,
                      color: const Color(0xff45464D),
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

  Widget _row(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            color: const Color(0xff45464D),
          ),
        ),
        const Spacer(),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}