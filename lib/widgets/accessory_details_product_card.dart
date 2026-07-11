import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class AccessoryDetailsProductCard extends StatelessWidget {
  final String image;
  final String accessoryName;
  final String category;
  final String orderNumber;
  final String status;

  const AccessoryDetailsProductCard({
    super.key,
    required this.image,
    required this.accessoryName,
    required this.category,
    required this.orderNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(14.r),
                ),
                child: _buildImage(),
              ),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff334155),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 24.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accessoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 21.sp,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        category,
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff52617A),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14.w),
                Container(
                  width: 94.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffE5E7EB),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    orderNumber,
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff45464D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final path = image.trim();

    if (path.isEmpty || path == 'null') {
      return _placeholder();
    }

    if (ImageHelper.isLocalFile(path)) {
      return Image.file(
        File(path),
        width: double.infinity,
        height: 255.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.network(
      ImageHelper.resolveServerUrl(path),
      width: double.infinity,
      height: 255.h,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 255.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.build_outlined,
        size: 68.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}