import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
class CustomMainContainer extends StatelessWidget {
  final Widget child;

  const CustomMainContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColor.txtColor2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: child,
      ),
    );
  }
}