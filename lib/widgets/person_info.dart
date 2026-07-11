import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/emp_avater.dart';

class EmployeeProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final bool isActive;
  final String imageUrl;

  const EmployeeProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.isActive,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Opacity(
              opacity: isActive ? 1.0 : 0.55,
              child: EmployeeAvatar(
                imagePath: imageUrl,
                size: 110,
                isCircle: true,
              ),
            ),

            Positioned(
              bottom: 4.h,
              right: 6.w,
              child: Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.w,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 25.sp,
          ),
        ),

        SizedBox(height: 6.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Badge(
              text: role,
              color: const Color(0xff57657A),
              bckground: const Color(0xff57657A),
            ),
            SizedBox(width: 8.w),
            _Badge(
              text: isActive ? "ACTIVE" : "NOTACTIVE",
              color: isActive ? Colors.green : Colors.red,
              icon: Icons.check_circle,
            ),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? bckground;
  final IconData? icon;
  const _Badge({required this.text, this.color, this.bckground, this.icon});

  @override
  Widget build(BuildContext context) {
    final txtcolor = color ?? const Color(0xffEEF4FF);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xffE5E7EB)).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14.sp,
                color: txtcolor,
              ),
              SizedBox(width: 5.w),
            ],
            Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                color: txtcolor,
                letterSpacing: .7,
              ),
            ),
          ]),
    );
  }
}