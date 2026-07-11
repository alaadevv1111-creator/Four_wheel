import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/widgets/custom_textfield.dart';

class StaffFilterSearch extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final String hintText;

  const StaffFilterSearch({
    super.key,
    required this.selectedIndex,
    required this.onFilterChanged,
    required this.searchController,
    this.onSearchChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ["All\nPersonnel", "Drivers", "Mechanics"];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onFilterChanged(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColor.primaryGradient : null,
                      color: isSelected ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        height: 1.2,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xff6B7280),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            color: const Color(0xff111827),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.manrope(
              fontSize: 16.sp,
              color: const Color(0xffC4C4C4),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 30.sp,
              color: const Color(0xff6B7280),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: const BorderSide(color: Color(0xffEEF0F3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: const BorderSide(color: Color(0xffEEF0F3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: const BorderSide(color: Color(0xffCBD5E1)),
            ),
          ),
        ),
      ],
    );
  }
}