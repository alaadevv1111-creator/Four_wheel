import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceOrderCard extends StatelessWidget {
  final String requestNumber;
  final String serviceName;
  final String date;
  final String time;
  final String location;
  final String status;
  final VoidCallback onDetailsTap;
  final VoidCallback onCancelTap;

  const ServiceOrderCard({
    super.key,
    required this.requestNumber,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.onDetailsTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final String displayStatus = _displayStatus(status);
    final bool isPending = displayStatus.toLowerCase() == 'pending';

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  requestNumber,
                  style: GoogleFonts.manrope(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff45464D),
                  ),
                ),
              ),
              _statusBadge(displayStatus),
            ],
          ),

          SizedBox(height: 14.h),

          Text(
            serviceName,
            style: GoogleFonts.manrope(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff191C1E),
            ),
          ),

          SizedBox(height: 22.h),

          _infoRow(
            icon: Icons.calendar_today_outlined,
            text: '$date • $time',
          ),

          SizedBox(height: 18.h),

          _infoRow(
            icon: Icons.location_on_outlined,
            text: location,
          ),

          SizedBox(height: 28.h),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onDetailsTap,
                  child: Container(
                    height: 58.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F2F4),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        'Request Details',
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff191C1E),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (isPending) ...[
                SizedBox(width: 12.w),

                Expanded(
                  child: GestureDetector(
                    onTap: onCancelTap,
                    child: Container(
                      height: 58.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xffCBD5E1),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel Request',
                          style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xff191C1E),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _displayStatus(String value) {
    final s = value.trim().toLowerCase();
    if (s == 'active') return 'In Progress';
    if (s == 'inprogress' || s == 'in_progress' || s == 'in progress') return 'In Progress';
    if (s == 'completed') return 'Completed';
    if (s == 'pending') return 'Pending';
    return value;
  }

  Widget _statusBadge(String displayStatus) {
    final s = displayStatus.trim().toLowerCase();

    Color bgColor;
    Color textColor;

    if (s == 'pending') {
      bgColor = const Color(0xffFFF2CC);
      textColor = const Color(0xffB45309);
    } else if (s == 'in progress') {
      bgColor = const Color(0xffDBEAFE);
      textColor = const Color(0xff2563EB);
    } else {
      bgColor = const Color(0xffDCFCE7);
      textColor = const Color(0xff15803D);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        displayStatus.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: const Color(0xff45464D),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            text.isEmpty ? '-' : text,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: const Color(0xff45464D),
            ),
          ),
        ),
      ],
    );
  }
}