import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCarCard extends StatelessWidget {
  final String carImage;
  final String model;
  final String brand;
  final String type;
  final String pricePerDay;
  final bool isAvailable;
  final String availabilityText;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onViewDetailsTap;

  const UserCarCard({
    super.key,
    required this.carImage,
    required this.model,
    required this.brand,
    required this.type,
    required this.pricePerDay,
    required this.isAvailable,
    required this.availabilityText,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
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
          Stack(
            children: [
              _buildCarImage(),

              Positioned(
                left: 18.w,
                top: 14.h,
                child: _availabilityBadge(),
              ),

              Positioned(
                right: 16.w,
                top: 16.h,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xff101828),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(26.w, 26.h, 26.w, 26.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff101828),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  '$brand • $type',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff45464D),
                  ),
                ),

                SizedBox(height: 28.h),

                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$$pricePerDay',
                            style: GoogleFonts.manrope(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                          TextSpan(
                            text: ' /day',
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff45464D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: onViewDetailsTap,
                      child: Container(
                        width: 140.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff334155),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

  Widget _availabilityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        availabilityText.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: isAvailable
              ? const Color(0xff15803D)
              : const Color(0xff52617A),
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    if (carImage.startsWith('http')) {
      return Image.network(
        carImage,
        width: double.infinity,
        height: 270.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (carImage.isNotEmpty) {
      return Image.file(
        File(carImage),
        width: double.infinity,
        height: 270.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 270.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.directions_car_filled_outlined,
        size: 70.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}