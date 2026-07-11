import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// [DeleteConfirmationDialog] هي نافذة منبثقة (Dialog) تُستخدم للتأكيد قبل إجراء عملية الحذف.
/// تم تصميمها بشكل عصري يتضمن تأثير "تغبيش" الخلفية لجذب انتباه المستخدم.
class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onDelete; // الدالة التي سيتم تنفيذها عند تأكيد الحذف
  final String title; // عنوان النافذة
  final String content; // نص الرسالة التحذيرية

  const DeleteConfirmationDialog({
    super.key,
    required this.onDelete,
    this.title = "Delete Item?",
    this.content = "Are you sure you want to delete this accessory? This action cannot be undone.",
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      // تطبيق تأثير التغبيش (Blur) على ما خلف النافذة
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF131B2E),
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.manrope(color: const Color(0xFF45464D)),
        ),
        actions: [
          // زر الإلغاء
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.manrope(color: const Color(0xFF6B7280)),
            ),
          ),
          // زر الحذف النهائي
          TextButton(
            onPressed: () {
              Get.back(); // إغلاق النافذة
              onDelete(); // تنفيذ عملية الحذف
            },
            child: Text(
              "Delete",
              style: GoogleFonts.manrope(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
