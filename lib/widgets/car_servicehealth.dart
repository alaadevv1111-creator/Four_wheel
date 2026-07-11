import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/constants/colors.dart';

class ServiceHealthCard extends StatelessWidget {
  const ServiceHealthCard({
    super.key,
    required this.lastInspectionDate,
    this.status = 'PERFECT',
  });

  final String lastInspectionDate;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Service Health',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.titleBlack,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.history,
                size: 17.sp,
                color: AppColor.titleBlack,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Container(
            height: 72.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColor.scaffoldBg,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColor.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.build,
                    size: 20.sp,
                    color: AppColor.success,
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LAST INSPECTION',
                      style: TextStyle(
                        fontSize: 11.sp,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textGrey2,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      lastInspectionDate,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.titleBlack,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.successLight,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: AppColor.success,
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
}