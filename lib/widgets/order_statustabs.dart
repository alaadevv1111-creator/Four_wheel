import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserOrderStatusTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const UserOrderStatusTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == tabs.length - 1 ? 0 : 14.w,
              ),
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff111827)
                        : const Color(0xffF1F2F4),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Text(
                    tabs[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff45464D),
                    ),
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