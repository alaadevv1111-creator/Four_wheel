import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardTitleSection extends StatelessWidget {
  final String smallTitle;
  final String bigTitle;

  const DashboardTitleSection({
    super.key,
    required this.smallTitle,
    required this.bigTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          smallTitle,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColor.bcolorsmalltitle,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          bigTitle,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColor.bcolorbigtitle,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}