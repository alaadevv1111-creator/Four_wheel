import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MechanicCustomerCard extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final String customerImage;
  final String memberSince;

  const MechanicCustomerCard({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.customerImage,
    required this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          ClipOval(
            child: _buildCustomerImage(),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff191C1E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  memberSince.isEmpty ? customerPhone : memberSince,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            ),
          ),
          _circleIcon(Icons.phone_outlined),
          SizedBox(width: 10.w),
          _circleIcon(Icons.chat_bubble_outline),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 46.w,
      height: 46.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffE5E7EB),
      ),
      child: Icon(
        icon,
        size: 23.sp,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCustomerImage() {
    if (customerImage.startsWith('http')) {
      return Image.network(
        customerImage,
        width: 56.w,
        height: 56.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (customerImage.isNotEmpty) {
      return Image.file(
        File(customerImage),
        width: 56.w,
        height: 56.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 56.w,
      height: 56.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.person,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}