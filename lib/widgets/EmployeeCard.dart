import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/emp_avater.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final String status;
  final String employeeId;
  final String imageUrl;
  final Color? statusColor;
  final double borderRadius;
  final VoidCallback? onTap;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.status,
    required this.employeeId,
    required this.imageUrl,
    this.statusColor,
    this.borderRadius = 12.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status.toLowerCase() == 'active';

    final Color dotColor = statusColor ??
        (isActive ? const Color(0xFF10B981) : const Color(0xFFCBD5E1));

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmployeeAvatar(
                imagePath: imageUrl,
                size: 65,
                borderRadius: 16,
                opacity: isActive ? 1.0 : 0.5,
              ),
              SizedBox(height: 16.h),

              Text(
                name,
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4.h),

              Text(
                role.toUpperCase(),
                style: GoogleFonts.manrope(
                  fontSize: 12.sp,
                  color: const Color(0xFF515F74),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                ),
              ),

              SizedBox(height: 20.h),
              const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                          boxShadow: isActive ? [
                            BoxShadow(
                              color: dotColor.withOpacity(0.6),
                              blurRadius: 6.r,
                              spreadRadius: 2.r,
                            )
                          ] : null,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        status.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          letterSpacing: 0.55,
                          fontWeight: FontWeight.normal,
                          color: isActive ? const Color(0xFF475569) : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      "ID: $employeeId",
                      style: GoogleFonts.manrope(
                        fontSize: 10.sp,
                        color: const Color(0xFF76777D),
                        fontWeight: FontWeight.normal,
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