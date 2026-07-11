import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCarSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const UserCarSearchField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: const Color(0xffE5E7EB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 26.sp,
            color: const Color(0xff45464D),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for model, brand, or type...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff8A8F98),
                ),
              ),
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff101828),
              ),
            ),
          ),
        ],
      ),
    );
  }
}