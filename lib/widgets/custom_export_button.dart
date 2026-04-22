import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomExportButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomExportButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColor.colorbackexport,
              blurRadius: 10,
              offset:Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(
              Icons.download_outlined,
              size: 16,
              color: AppColor.txtColor2,
            ),
            const SizedBox(width: 8),
            Text(
              "Export PDF",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.txtColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}