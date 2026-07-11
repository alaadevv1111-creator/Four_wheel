import 'package:flutter/material.dart';

import 'package:four_wheels/constants/colors.dart';

class CarInfoCard extends StatelessWidget {
  const CarInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding:  EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow:  [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Image.asset(icon,
           width: 22,
           height: 22,
           fit: BoxFit.contain,
         ),
           Spacer(),
          Text(
            label.toUpperCase(),
            style:  TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
              color: AppColor.textGrey2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.titleBlack,
            ),
          ),
        ],
      ),
    );
  }
}