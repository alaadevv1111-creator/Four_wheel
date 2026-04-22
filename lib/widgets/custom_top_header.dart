import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:four_wheels/constants/colors.dart';

class CustomTopHeader extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final String imagePath;
  final IconData? icon;

  const CustomTopHeader({
    super.key,
    required this.title,
    required this.imagePath,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon),
          const SizedBox(width: 8),
        ],

        Expanded(
          child: Text(
            title,
            style: textStyle,
          ),
        ),

        CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage(imagePath),
        ),
      ],
    );
  }
}