import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const UserBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isSelected ? 74.w : 62.w,
            height: 58.h,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: isSelected
                  ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.cardprim,
                  AppColor.cardprim2,
                ],
              )
                  : null,
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 12.r,
                  offset: Offset(0, 5.h),
                ),
              ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24.sp,
                  color: isSelected ? Colors.white : const Color(0xff8B98AD),
                ),
                SizedBox(height: 3.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xff8B98AD),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.h,
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(26.r),
          topLeft: Radius.circular(26.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 22.r,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          _navItem(icon: Icons.home_rounded, label: 'HOME', index: 0),
          _navItem(icon: Icons.directions_car_filled_outlined, label: 'CARS', index: 1),
          _navItem(icon: Icons.calendar_month_outlined, label: 'ORDERS', index: 2),
          _navItem(icon: Icons.build_outlined, label: 'ACCESSORIES', index: 3),
          _navItem(icon: Icons.person_outline, label: 'PROFILE', index: 4),
        ],
      ),
    );
  }
}