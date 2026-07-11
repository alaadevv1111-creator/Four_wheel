import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class EmployeeAvatar extends StatelessWidget {
  final String imagePath;
  final double? size;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isCircle;
  final double opacity;
  final VoidCallback? onEditTap;

  const EmployeeAvatar({
    super.key,
    required this.imagePath,
    this.size,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.isCircle = true,
    this.opacity = 1.0,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final double finalWidth = width ?? size?.w ?? 80.w;
    final double finalHeight = height ?? size?.h ?? 80.h;
    final String path = imagePath.trim();

    return GestureDetector(
      onTap: onEditTap,
      child: Opacity(
        opacity: opacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            isCircle ? finalWidth / 2 : borderRadius.r,
          ),
          child: Container(
            width: finalWidth,
            height: finalHeight,
            color: const Color(0xffD9DEE3),
            child: _buildImage(path),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (ImageHelper.isEmpty(path)) {
      return _placeholder();
    }

    if (ImageHelper.isLocalFile(path)) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          print('LOCAL FILE IMAGE ERROR: $path');
          return _placeholder();
        },
      );
    }

    final String url = ImageHelper.resolveServerUrl(path);

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        print('NETWORK IMAGE ERROR: $url');
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.person,
        size: 42.sp,
        color: const Color(0xff98A2B3),
      ),
    );
  }
}