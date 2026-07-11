import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminRentalOrderCard extends StatelessWidget {
  final String image;
  final String rentalId;
  final String carName;
  final String customerName;
  final String date;
  final String price;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onDelete;
  final VoidCallback onDetails;
  final VoidCallback onComplete;

  const AdminRentalOrderCard({
    super.key,
    required this.image,
    required this.rentalId,
    required this.carName,
    required this.customerName,
    required this.date,
    required this.price,
    required this.status,
    required this.onAccept,
    required this.onDelete,
    required this.onDetails,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status.toLowerCase() == 'pending';
    final isInProgress = status.toLowerCase() == 'in progress';

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _buildImage(),
          ),
          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rentalId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xff101828),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _statusBadge(status),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  carName,
                  style: GoogleFonts.manrope(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  customerName,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff64748B),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16.sp,
                      color: const Color(0xff64748B),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      date,
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff64748B),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '\$$price',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff101828),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    if (isPending)
                      _actionButton(
                        text: 'Accept',
                        color: const Color(0xffDCFCE7),
                        textColor: const Color(0xff15803D),
                        icon: Icons.check_circle_outline,
                        onTap: onAccept,
                      ),

                    if (isInProgress)
                      _actionButton(
                        text: 'Complete',
                        color: const Color(0xffDBEAFE),
                        textColor: const Color(0xff2563EB),
                        icon: Icons.done_all,
                        onTap: onComplete,
                      ),

                    _actionButton(
                      text: 'Delete',
                      color: const Color(0xffFEE2E2),
                      textColor: const Color(0xffDC2626),
                      icon: Icons.delete_outline,
                      onTap: onDelete,
                    ),

                    _actionButton(
                      text: 'Details',
                      color: Colors.white,
                      textColor: const Color(0xff334155),
                      icon: Icons.info_outline,
                      borderColor: const Color(0xffCBD5E1),
                      onTap: onDetails,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 64.w,
        height: 64.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        width: 64.w,
        height: 64.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (image.isNotEmpty) {
      return Image.file(
        File(image),
        width: 64.w,
        height: 64.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 64.w,
      height: 64.h,
      color: const Color(0xffF1F5F9),
      child: Icon(
        Icons.directions_car_outlined,
        color: const Color(0xff94A3B8),
      ),
    );
  }

  Widget _statusBadge(String text) {
    Color bg;
    Color color;

    if (text.toLowerCase() == 'pending') {
      bg = const Color(0xffFEF3C7);
      color = const Color(0xffD97706);
    } else if (text.toLowerCase() == 'in progress') {
      bg = const Color(0xffDBEAFE);
      color = const Color(0xff2563EB);
    } else {
      bg = const Color(0xffDCFCE7);
      color = const Color(0xff15803D);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required Color color,
    required Color textColor,
    required IconData icon,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
          border: borderColor == null
              ? null
              : Border.all(
            color: borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: textColor,
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}