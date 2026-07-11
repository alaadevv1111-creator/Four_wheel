import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? backgroundGraphic;
  final VoidCallback? onTap;

  const CustomServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundGraphic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342.w,
        height: 156.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // الرسومات الجانبية (Background Graphic)
              if (backgroundGraphic != null)
                Positioned(
                  bottom: -15.h,
                  right: -10.w,
                  child: Opacity(
                    opacity: 0.05,
                    child: backgroundGraphic,
                  ),
                ),
              
              Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الأيقونة العلوية
                    Icon(
                      icon,
                      color: Colors.black,
                      size: 30.r,
                    ),
                    SizedBox(height: 16.h),
                    // منطقة النصوص مع استخدام Flexible و FittedBox
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                title,
                                style: GoogleFonts.manrope(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800, // ExtraBold
                                  color: AppColor.primary, // 191C1E
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Flexible(
                            child: Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400, // Regular
                                color: AppColor.bcolorsmalltitle, // 45464D
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
