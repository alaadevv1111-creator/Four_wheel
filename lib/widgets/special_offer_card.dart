import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialOfferCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String validUntil;
  final VoidCallback? onTap;

  const SpecialOfferCard({
    super.key,
    required this.imageUrl,
    this.title = "SPECIAL OFFER",
    this.subtitle = "15% off weekend rentals",
    this.validUntil = "Valid until Oct 31, 2023.",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 358.w,
        height: 120.h, // Increased height slightly for better text clarity
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Row(
            children: [
              // Content Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    top: 15.h,
                    bottom: 15.h,
                    right: 5.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            title.toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 13.sp, // Enlarged
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Flexible(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            subtitle,
                            style: GoogleFonts.manrope(
                              fontSize: 26.sp, // Enlarged and Bold
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            validUntil,
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp, // Enlarged
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Image Section
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    width: 140.w,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 140.w,
                      color: Colors.black26,
                      child: const Icon(Icons.directions_car, color: Colors.white24),
                    ),
                  ),
                  // Simple gradient on top of image to blend left side
                  Container(
                    width: 140.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.4],
                        colors: [
                          const Color(0xFF131B2E), // Match background exactly
                          const Color(0xFF131B2E).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
