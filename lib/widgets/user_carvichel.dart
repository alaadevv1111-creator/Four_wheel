import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarAboutSection extends StatelessWidget {
  final String description;
  final RxBool isExpanded;
  final VoidCallback onToggle;

  const CarAboutSection({
    super.key,
    required this.description,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 48.h, 28.w, 0),
      child: Obx(
            () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About this Vehicle',
              style: GoogleFonts.manrope(
                fontSize: 23.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              description,
              maxLines: isExpanded.value ? null : 3,
              overflow:
              isExpanded.value ? TextOverflow.visible : TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                height: 1.55,
                fontWeight: FontWeight.w400,
                color: const Color(0xff45464D),
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: onToggle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isExpanded.value ? 'Show Less' : 'Show More',
                    style: GoogleFonts.manrope(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}