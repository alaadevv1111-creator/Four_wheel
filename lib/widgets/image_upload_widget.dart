import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashed_border_painter.dart';

/// [ImageUploadWidget] هي الويدجت المسؤولة عن واجهة اختيار وتحميل الصور.
class ImageUploadWidget extends StatelessWidget {
  final RxString imagePath; // مسار الصورة المختارة
  final RxBool isImageSelected; // حالة تبيّن ما إذا تم اختيار صورة أم لا
  final RxBool error; // حالة تبيّن وجود خطأ
  final VoidCallback onTap; // الوظيفة التي تُستدعى عند الضغط
  final double? width; // العرض (اختياري)
  final double? height; // الارتفاع (اختياري)

  const ImageUploadWidget({
    super.key,
    required this.imagePath,
    required this.isImageSelected,
    required this.error,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Obx(() => CustomPaint(
            painter: DashedBorderPainter(),
            child: Container(
              width: width ?? 268.w,
              height: height ?? 258.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8EA),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: isImageSelected.value
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: imagePath.value.startsWith('http') || imagePath.value.startsWith('assets')
                          ? Image.network(imagePath.value, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image))
                          : Image.file(File(imagePath.value), fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 33.sp,
                          color: error.value ? Colors.red : const Color(0xFF45464D),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "UPLOAD IMAGE",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: error.value ? Colors.red : const Color(0xFF45464D),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
            ),
          )),
        ),
        Obx(() => error.value
            ? Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w),
                child: Text(
                  "Image is required",
                  style: GoogleFonts.manrope(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}
