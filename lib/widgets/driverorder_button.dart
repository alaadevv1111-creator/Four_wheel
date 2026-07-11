import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/widgets/custom_button.dart';

class DriverOrderActions extends StatelessWidget {
  final VoidCallback? onStart;
  final VoidCallback? onComplete;

  const DriverOrderActions({
    super.key,
    required this.onStart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 20.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Start Task',
              textcolor: onStart == null
                  ? const Color(0xff94A3B8)
                  : Colors.white,
              color: onStart == null
                  ? const Color(0xffE5E7EB)
                  : const Color(0xff243044),
              icon: Icons.play_arrow_outlined,
              height: 52.h,
              fontwight: FontWeight.w700,
              fontsize: 15.sp,
              onTap: onStart ?? () {},
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: CustomButton(
              text: 'Complete',
              textcolor: onComplete == null
                  ? const Color(0xff94A3B8)
                  : const Color(0xff191C1E),
              color: const Color(0xffE5E7EB),
              height: 52.h,
              fontwight: FontWeight.w700,
              fontsize: 15.sp,
              onTap: onComplete ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}