import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class ExpertTechnicianCard extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String services;
  final String experience;
  final VoidCallback onCallTap;

  const ExpertTechnicianCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.services,
    required this.experience,
    required this.onCallTap,
  });

  bool get isAssigned {
    return name.trim().isNotEmpty && name.trim() != 'Not assigned yet';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          _avatar(),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAssigned ? name : 'Not assigned yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),

                SizedBox(height: 5.h),

                if (isAssigned)
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16.sp,
                        color: const Color(0xffF59E0B),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        rating,
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff101828),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Text(
                          experience,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff64748B),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Waiting for admin assignment',
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff64748B),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          GestureDetector(
            onTap: isAssigned ? onCallTap : null,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: isAssigned
                    ? const Color(0xff101828)
                    : const Color(0xffE5E7EB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call_outlined,
                color: isAssigned ? Colors.white : const Color(0xff94A3B8),
                size: 21.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    final path = image.trim();

    if (!isAssigned || path.isEmpty || path == 'null') {
      return CircleAvatar(
        radius: 26.r,
        backgroundColor: const Color(0xffE5E7EB),
        child: Icon(
          Icons.person,
          color: const Color(0xff94A3B8),
          size: 28.sp,
        ),
      );
    }

    if (ImageHelper.isLocalFile(path)) {
      return CircleAvatar(
        radius: 26.r,
        backgroundImage: FileImage(File(path)),
      );
    }

    return CircleAvatar(
      radius: 26.r,
      backgroundImage: NetworkImage(
        ImageHelper.resolveServerUrl(path),
      ),
    );
  }
}