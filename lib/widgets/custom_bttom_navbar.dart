import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _navItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return SizedBox(
      width: 72.w,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
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
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 22.w,
              height: 22.h,
              color: isSelected ? Colors.white : const Color(0xff9CA3AF),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xff9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _item({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: _navItem(
        iconPath: iconPath,
        label: label,
        isSelected: currentIndex == index,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex = currentIndex < 0 || currentIndex > 4 ? 0 : currentIndex;

    return Container(
      height: 90.h,
      padding: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: [
          _item(iconPath: 'assets/images/dashbordico.png', label: 'DASHBOARD', index: 0),
          _item(iconPath: 'assets/images/rentlsIcon.png', label: 'RENTALS', index: 1),
          _item(iconPath: 'assets/images/employyIcon.png', label: 'EMPLOYEE', index: 2),
          _item(iconPath: 'assets/images/iconcar.png', label: 'CARS', index: 3),
          _item(iconPath: 'assets/images/partsicon.png', label: 'ACCESSORIES', index: 4),
        ],
      ),
    );
  }
}