import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeTaskTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onChanged;

  const EmployeeTaskTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Current',
      'In Progress',
      'Completed',
    ];

    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xff111827)
                    : const Color(0xffE5E7EB),
                borderRadius: BorderRadius.circular(40.r),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 16.r,
                    offset: Offset(0, 8.h),
                  ),
                ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xff45464D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}