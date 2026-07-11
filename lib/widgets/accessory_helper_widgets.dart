import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../screens/dash_bord.dart';
import '../screens/Accessories.dart';

/// [AccessoryStyles] يوحد أنماط النصوص لضمان التناسق التام.
class AccessoryStyles {
  static TextStyle labelStyle = GoogleFonts.manrope(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF45464D),
    letterSpacing: 1.2,
  );

  // ستايل القيم العادية
  static TextStyle valueStyle14 = GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF191C1E),
  );

  // ستايل القيم العريضة (Bold)
  static TextStyle boldValueStyle = GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF191C1E),
  );

  // ستايل نصوص حقول الإدخال
  static TextStyle fieldTextStyle(FontWeight weight) => GoogleFonts.manrope(
    fontSize: 16.sp,
    color: const Color(0xFF191C1E),
    fontWeight: weight,
  );
}

/// [AccessoryUtils] يحتوي على الوظائف المنطقية المشتركة.
class AccessoryUtils {
  static String get formattedTodayDate {
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  static String calculateStatus(int qty) {
    if (qty == 0) return "Out of Stock";
    if (qty >= 1 && qty <= 5) return "Low Stock";
    return "In Stock";
  }

  // تحديث دالة توليد SKU بناءً على طلبك الجديد:
  // (أول حرف من الفئة + المعرف + أول حرف من كل كلمة في الاسم) مع فواصل
  static String generateSKU({required String category, required String name, required int id}) {
    final String catPart = category.trim().isNotEmpty ? category.trim()[0].toUpperCase() : "";
    final String idPart = id.toString();
    final String namePart = name.trim().split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join("");
    return "$catPart-$idPart-$namePart";
  }
}

/// [AccessoryInfoColumn] ويدجت لعرض (عنوان فوق قيمة)
class AccessoryInfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  const AccessoryInfoColumn({
    super.key,
    required this.label,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label.toUpperCase(), style: AccessoryStyles.labelStyle),
        SizedBox(height: 8.h),
        Text(value, style: AccessoryStyles.valueStyle14),
      ],
    );
  }
}

/// [AccessoryBadge] ويدجت الشارات (مثل حالة المخزون أو النوع)
class AccessoryBadge extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const AccessoryBadge({super.key, required this.text, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20.r)),
      child: Text(
        text,
        style: GoogleFonts.manrope(fontSize: 12.sp, color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// [AccessoryImagePicker] كلاس يعزل كود الـ BottomSheet الخاص باختيار الصور.
class AccessoryImagePicker {
  static void showSourceSheet({
    required BuildContext context,
    required Function(ImageSource source) onImageSelected,
  }) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose Image Source",
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: "Camera",
                  onTap: () {
                    Get.back();
                    onImageSelected(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  onTap: () {
                    Get.back();
                    onImageSelected(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  static Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: const BoxDecoration(
              color: AppColor.mainBc,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.primary, size: 30.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class AccessoryTabButton extends StatelessWidget {
  final AccController controller;
  final int index;
  final String text;
  final IconData? icon;

  const AccessoryTabButton({
    super.key,
    required this.controller,
    required this.index,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.handleTabPress(index),
        child: Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 45.h,
          decoration: BoxDecoration(
            color: controller.selectedIndex.value == index ? const Color(0xFF131B2E) : const Color(0xFFE6E8EA),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: controller.selectedIndex.value == index ? Colors.white : const Color(0xFF191C1E), size: 18.sp),
                SizedBox(width: 4.w),
              ],
              Text(
                text,
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: controller.selectedIndex.value == index ? Colors.white : const Color(0xFF191C1E),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
