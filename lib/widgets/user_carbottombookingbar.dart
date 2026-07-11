import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarBookingBottomBar extends StatelessWidget {
  final int totalPrice;
  final RxBool isBooking;
  final VoidCallback onBookNow;

  const CarBookingBottomBar({
    super.key,
    required this.totalPrice,
    required this.isBooking,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        margin: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 0),
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Total',
                    style: GoogleFonts.manrope(
                      fontSize: 13.sp,
                      color: const Color(0xff64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$$totalPrice',
                    style: GoogleFonts.manrope(
                      fontSize: 24.sp,
                      color: const Color(0xff101828),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 54.h,
              child: ElevatedButton(
                onPressed: isBooking.value ? null : onBookNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff344054),
                  disabledBackgroundColor: const Color(0xff94A3B8),
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: Text(
                  isBooking.value ? 'Checking...' : 'Book Now',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}