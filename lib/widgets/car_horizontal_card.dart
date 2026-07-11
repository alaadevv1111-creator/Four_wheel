import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CarHorizontalCard extends StatelessWidget {
  final String imageUrl;
  final String carName;
  final String subtitle;
  final VoidCallback? onTap;

  const CarHorizontalCard({
    super.key,
    required this.imageUrl,
    required this.carName,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 358.w,
        height: 90.h,
        decoration: BoxDecoration(
          color: AppColor.cardBg, // FEFDFA
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
          child: Row(
            children: [
              // صورة السيارة (h64 w96)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  imageUrl,
                  width: 96.w,
                  height: 64.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.w),
              // المعلومات النصية
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          carName,
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold, // Bold (Porsche Taycan)
                            color: AppColor.bcolorbigtitle, // 0F172A
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500, // Medium
                          color: AppColor.textMuted, // 64748B
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // أيقونة الانتقال
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: const Color(0xFFC6C6CD),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
