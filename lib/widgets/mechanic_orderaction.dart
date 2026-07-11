import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/widgets/custom_button.dart';

class MechanicOrderActions extends StatelessWidget {
  final VoidCallback? onStartRepair;
  final VoidCallback? onCompleteRepair;

  const MechanicOrderActions({
    super.key,
    required this.onStartRepair,
    required this.onCompleteRepair,
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
              text: 'Start Repair',
              textcolor: onStartRepair == null
                  ? const Color(0xff94A3B8)
                  : Colors.white,
              color: onStartRepair == null
                  ? const Color(0xffE5E7EB)
                  : const Color(0xff243044),
              height: 52.h,
              fontwight: FontWeight.w700,
              fontsize: 14.sp,
              onTap: onStartRepair ?? () {},
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: CustomButton(
              text: 'Complete',
              textcolor: onCompleteRepair == null
                  ? const Color(0xff94A3B8)
                  : const Color(0xff191C1E),
              color: const Color(0xffE5E7EB),
              height: 52.h,
              fontwight: FontWeight.w700,
              fontsize: 14.sp,
              onTap: onCompleteRepair ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}