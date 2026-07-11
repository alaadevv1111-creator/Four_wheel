import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInputField extends StatelessWidget {
  final String title;
  final String hint;
  final IconData? icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const UserInputField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDescription = maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
            color: const Color(0xff45464D),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: 370.w,
          height: isDescription ? 120.h : 70.h,
          padding: EdgeInsets.symmetric(
            horizontal: icon == null ? 28.w : 20.w,
            vertical: isDescription ? 18.h : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
            isDescription ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 28.sp,
                  color: const Color(0xff52617A),
                ),
                SizedBox(width: 18.w),
              ],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  validator: validator,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffB8BCC6),
                    ),
                  ),
                  style: GoogleFonts.manrope(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff191C1E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}