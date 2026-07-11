import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/constants/colors.dart';

class RentalRateCard extends StatelessWidget {
  const RentalRateCard({
    super.key,
    required this.rentalInvestment,
    required this.weeklyRate,
  });

  final String rentalInvestment;
  final String weeklyRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppColor.rateCard,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _RateItem(
              label: 'RENTAL INVESTMENT',
              value: rentalInvestment,
              suffix: '/ day',
            ),
          ),
          Container(
            width: 1.w,
            height: 52.h,
            color: AppColor.divider,
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: _RateItem(
              label: 'WEEKLY RATE',
              value: weeklyRate,
              suffix: '/ week',
            ),
          ),
        ],
      ),
    );
  }
}

class _RateItem extends StatelessWidget {
  const _RateItem({
    required this.label,
    required this.value,
    required this.suffix,
  });

  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w700,
            color: const Color(0xffC0C6D2),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26.sp,
                height: 1,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5.w),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                suffix,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xffD7DBE4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}