import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CarStatus {
  available,
  rented,
  maintenance,
}

class CustomCarCard extends StatelessWidget {
  final String title;
  final String brand;
  final String year;
  final String licensePlate;
  final String dailyPrice;
  final String imageUrl;
  final CarStatus status;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CustomCarCard({
    super.key,
    required this.title,
    required this.brand,
    required this.year,
    required this.licensePlate,
    required this.dailyPrice,
    required this.imageUrl,
    required this.status,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: _buildCarImage(),
                ),
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: _buildStatusBadge(),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: GoogleFonts.manrope(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF191C1E),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: onEdit,
                            icon: Icon(
                              Icons.edit_outlined,
                              color: const Color(0xFF45464D),
                              size: 22.sp,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete_outline,
                              color: const Color(0xFFBA1A1A).withOpacity(0.7),
                              size: 22.sp,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    '$brand • $year',
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    licensePlate.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF45464D),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  const Divider(
                    color: Color(0xFFF1F5F9),
                    thickness: 1.5,
                  ),

                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      _buildStat(
                        icon: Icons.attach_money_rounded,
                        label: '$dailyPrice / day',
                      ),
                      SizedBox(width: 18.w),
                      _buildStat(
                        icon: Icons.confirmation_number_outlined,
                        label: licensePlate,
                      ),
                    ],
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
    if (imageUrl.isEmpty) {
      return _imagePlaceholder();
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 180.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: 180.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    return Image.file(
      File(imageUrl),
      height: 180.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(
        Icons.car_rental,
        size: 50.sp,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color bgColor;
    Color textColor;
    BoxBorder border;

    if (status == CarStatus.available) {
      text = "AVAILABLE";
      bgColor = const Color(0xFFE8F8F0);
      textColor = const Color(0xFF10B981);
      border = Border.all(color: const Color(0xFFE2E8F0));
    } else if (status == CarStatus.rented) {
      text = "RENTED";
      bgColor = const Color(0xFFFFF3CD);
      textColor = const Color(0xFFC98900);
      border = Border.all(color: const Color(0xFFFFE8A3));
    } else {
      text = "MAINTENANCE";
      bgColor = const Color(0xFFFFE4E6);
      textColor = const Color(0xFFDC2626);
      border = Border.all(color: const Color(0xFFFFCDD2));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: border,
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: const Color(0xFF57657A),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              label.isEmpty ? '-' : label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF191C1E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}