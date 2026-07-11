import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../screens/Profile_admin_sitting.dart';
import '../screens/user_profile_screen.dart';

class Profileavator extends StatelessWidget {
  final double radius;
  final double fontSize;
  final Color? backgroundColor;
  final Border? border;

  const Profileavator({
    super.key,
    required this.radius,
    required this.fontSize,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController(), permanent: true);

    return Obx(() {
      final localFile = controller.localImageFile.value;
      final imageUrl = controller.profileImageUrl.value;

      Widget imageChild;

      if (localFile != null) {
        imageChild = Image.file(
          localFile,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
        );
      } else if (imageUrl != null && imageUrl.trim().isNotEmpty) {
        imageChild = Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          headers: const {
            "ngrok-skip-browser-warning": "true",
            "Accept": "image/*",
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint("❌ Image Load Error on UI: $error");
            return _buildInitials(controller);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: radius,
                height: radius,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        );
      } else {
        imageChild = _buildInitials(controller);
      }

      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? const Color(0xFFF1F5F9),
          border: border ?? Border.all(color: Colors.white, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: imageChild,
      );
    });
  }

  Widget _buildInitials(UserProfileController controller) {
    return Center(
      child: Text(
        controller.initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }
}