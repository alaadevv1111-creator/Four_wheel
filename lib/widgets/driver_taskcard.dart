import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverBookingTaskCard extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final String carName;
  final String carImage;
  final String plateNumber;
  final String pickupLocation;
  final String bookingDate;
  final String price;
  final String status;
  final VoidCallback? onTap;

  const DriverBookingTaskCard({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.carName,
    required this.carImage,
    required this.plateNumber,
    required this.pickupLocation,
    required this.bookingDate,
    required this.price,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildCarImage(),
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: _statusBadge(),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff191C1E),
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    plateNumber.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff64748B),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  const Divider(
                    color: Color(0xffF1F5F9),
                    thickness: 1.4,
                  ),

                  SizedBox(height: 16.h),

                  _infoRow(
                    icon: Icons.person_outline,
                    label: 'Customer',
                    value: customerName,
                  ),

                  SizedBox(height: 14.h),

                  _infoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: customerPhone,
                  ),

                  SizedBox(height: 14.h),

                  _infoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Pickup',
                    value: pickupLocation,
                  ),

                  SizedBox(height: 14.h),

                  _infoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Booking Date',
                    value: bookingDate,
                  ),

                  SizedBox(height: 18.h),

                  Text(
                    price,
                    style: GoogleFonts.manrope(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff191C1E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    if (carImage.isEmpty) {
      return _placeholder();
    }

    if (carImage.startsWith('http')) {
      return Image.network(
        carImage,
        height: 190.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.file(
      File(carImage),
      height: 190.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 190.h,
      width: double.infinity,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.directions_car_filled_outlined,
        size: 54.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: const Color(0xff57657A),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            '$label: ${value.isEmpty ? '-' : value}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff45464D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _statusBgColor(),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _statusBorderColor()),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: _statusTextColor(),
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Color _statusBgColor() {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('completed')) return const Color(0xffE8F8F0);
    if (lowerStatus.contains('progress')) return const Color(0xffFFF3CD);
    return const Color(0xffEEF4FF);
  }

  Color _statusTextColor() {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('completed')) return const Color(0xff10B981);
    if (lowerStatus.contains('progress')) return const Color(0xffC98900);
    return const Color(0xff475569);
  }

  Color _statusBorderColor() {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('completed')) return const Color(0xffD1FAE5);
    if (lowerStatus.contains('progress')) return const Color(0xffFFE8A3);
    return const Color(0xffD7E5FF);
  }
}