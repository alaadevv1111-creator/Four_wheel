import 'package:flutter/material.dart';

import 'package:four_wheels/constants/colors.dart';

class CarCategoryCard extends StatelessWidget {
  const CarCategoryCard({
    super.key,
    required this.category,
    required this.powerType,
  });

  final String category;
  final String powerType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding:  EdgeInsets.fromLTRB(20, 18, 20, 20),
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
           Icon(
            Icons.category_outlined,
            size: 22,
            color: AppColor.secondaryDark,
          ),
           Spacer(),
           Text(
            'CATEGORY',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
              color: AppColor.textGrey2,
            ),
          ),
           SizedBox(height: 8),
          Row(
            children: [
              Text(
                category,
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.titleBlack,
                ),
              ),
               Spacer(),
               Icon(
                Icons.flash_on,
                size: 14,
                color: AppColor.titleBlack,
              ),
               SizedBox(width: 4),
              Text(
                powerType.toUpperCase(),
                style:  TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColor.titleBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}