import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'package:four_wheels/utils/image_uelper.dart';
class CarRentalCard extends StatelessWidget {
  final String imageUrl;
  final String carName;
  final String price;
  final String rating;
  final String reviewsCount;
  final bool isAvailable;
  final bool isFavorite;
  final VoidCallback? onViewDetails;
  final VoidCallback? onFavoriteTap;

  const CarRentalCard({
    super.key,
    required this.imageUrl,
    required this.carName,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    this.isAvailable = true,
    this.isFavorite = false,
    this.onViewDetails,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 356.w,
      decoration: BoxDecoration(
        color: AppColor.cardBg, // FEFDFA
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // منطقة الصورة مع الأيقونات (Stack)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Image.network(
                  imageUrl,
                  height: 192.h,
                  width: 356.w,
                  fit: BoxFit.cover,
                  headers: const {'ngrok-skip-browser-warning': 'true'},
                ),
              ),
              // زر المفضلة
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: AppColor.cardBg, // FEFDFA
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColor.favoriteRed : AppColor.textMuted,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              // علامة الحالة: "Available Today" (أخضر) أو "Rented" (أحمر)
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColor.availableGreen // 16A34A
                        : const Color(0xffDC2626), // أحمر لغير المتاحة
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(radius: 3, backgroundColor: Colors.white),
                      SizedBox(width: 6.w),
                      Text(
                        isAvailable ? "Available Today" : "Rented",
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم السيارة والسعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          carName,
                          style: GoogleFonts.manrope(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold, // Bold
                            color: AppColor.bcolorbigtitle, // 0F172A
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "\$$price",
                          style: GoogleFonts.manrope(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800, // ExtraBold
                            color: AppColor.bcolorbigtitle, // 0F172A
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // التقييم و PER DAY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          rating,
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold, // Bold
                            color: AppColor.bcolorbigtitle, // 0F172A
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "($reviewsCount reviews)",
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500, // Medium
                            color: AppColor.textMuted, // 64748B
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "PER DAY",
                      style: GoogleFonts.manrope(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500, // Medium
                        color: AppColor.textMuted, // 64748B
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // زر View Details
                Center(
                  child: GestureDetector(
                    onTap: onViewDetails,
                    child: Container(
                      width: 324.w,
                      height: 41.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "View Details",
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold, // Bold
                          color: AppColor.bcolorbigtitle, // 0F172A
                        ),
                      ),
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
}