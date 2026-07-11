import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class AccessoryOrderCard extends StatelessWidget {
  final String image;
  final String orderNumber;
  final String accessoryName;
  final String orderDate;
  final String price;
  final VoidCallback onViewDetails;

  const AccessoryOrderCard({
    super.key,
    required this.image,
    required this.orderNumber,
    required this.accessoryName,
    required this.orderDate,
    required this.price,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: _buildImage(),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff41516A),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      accessoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff191C1E),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'Ordered: $orderDate',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff45464D),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      price,
                      style: GoogleFonts.manrope(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          CustomButton(
            text: 'View Details',
            textcolor: const Color(0xff191C1E),
            height: 50.h,
            color: const Color(0xffE5E7EB),
            fontwight: FontWeight.w900,
            fontsize: 15.sp,
            onTap: onViewDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (ImageHelper.isEmpty(image)) {
      return _placeholder();
    }

    if (ImageHelper.isLocalFile(image)) {
      return Image.file(
        File(image),
        width: 96.w,
        height: 96.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.network(
      ImageHelper.resolveServerUrl(image),
      width: 96.w,
      height: 96.h,
      fit: BoxFit.cover,
      headers: const {'ngrok-skip-browser-warning': 'true'},
      errorBuilder: (context, error, stackTrace) {
        print('ACCESSORY IMAGE ERROR: $error');
        print('ACCESSORY IMAGE URL: ${ImageHelper.resolveServerUrl(image)}');
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      width: 96.w,
      height: 96.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.build_outlined,
        size: 38.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}