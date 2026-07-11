import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [CustomImageView] هي ويدجت ذكية لعرض الصور من مصادر مختلفة.
/// تتعامل مع الصور القادمة من الإنترنت (URL) أو الصور المحلية (File) أو الصور المفقودة.
class CustomImageView extends StatelessWidget {
  final dynamic imagePath; // مسار الصورة (رابط أو مسار ملف)
  final BoxFit fit; // طريقة احتواء الصورة داخل الإطار
  final double? width; // عرض الصورة
  final double? height; // ارتفاع الصورة
  final BorderRadius? borderRadius; // حواف دائرية للصورة
  final Widget? placeholder; // ويدجت بديلة في حال عدم وجود صورة

  const CustomImageView({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // التحقق مما إذا كان المسار فارغاً
    if (imagePath == null || imagePath.toString().isEmpty) {
      imageWidget = placeholder ?? _buildDefaultPlaceholder();
    } else {
      final String path = imagePath.toString();
      // إذا كان الرابط يبدأ بـ http، يتم جلب الصورة من الإنترنت
      if (path.startsWith('http')) {
        imageWidget = Image.network(
          path,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (c, e, s) => placeholder ?? _buildDefaultPlaceholder(),
        );
      } else {
        // خلاف ذلك، يتم التعامل معها كملف محلي
        imageWidget = Image.file(
          File(path),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (c, e, s) => placeholder ?? _buildDefaultPlaceholder(),
        );
      }
    }

    // تطبيق الحواف الدائرية إذا وجدت
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  // الويدجت الافتراضية في حال عدم وجود صورة (Placeholder)
  Widget _buildDefaultPlaceholder() => Container(
        width: width,
        height: height,
        color: const Color(0xFFE6E8EA),
        child: Icon(
          Icons.person,
          color: const Color(0xFFADB5BD),
          size: (width != null) ? (width! * 0.6) : 40.sp,
        ),
      );
}
