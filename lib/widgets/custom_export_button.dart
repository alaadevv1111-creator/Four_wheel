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
      child: Align(
            alignment: Alignment.centerLeft,
            child: IntrinsicWidth(
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xffE6E8EA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_outlined, size: 14),
                      SizedBox(width: 5),
                      Text("Export PDF"),
                    ],
                  ),
                ),
              ),
            ),
          )

    );
  }
}