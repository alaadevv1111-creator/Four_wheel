import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomFilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r), // شكل دائري بالكامل (Pill)
          color: isSelected ? null : AppColor.colorbackexport, // E6E8EA
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColor.cardprim, AppColor.cardprim2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.cardprim2.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600, // Semi Bold
                    color: isSelected ? Colors.white : AppColor.bcolorsmalltitle, // 45464D
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
