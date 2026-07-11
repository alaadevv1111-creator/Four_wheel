import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserOrderTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const UserOrderTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xffF1F2F4),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  tabs[index],
                  style: GoogleFonts.manrope(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff45464D),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}