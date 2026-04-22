import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() =>
      _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {
  bool isYesSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment:
            isYesSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 140,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => isYesSelected = true);
                  },
                  child: Center(
                    child: Text(
                      "Yes, I have",
                      style: GoogleFonts.poppins(
                        color: isYesSelected
                            ? AppColor.buttonColor
                            : AppColor.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => isYesSelected = false);
                  },
                  child: Center(
                    child: Text(
                      "No, I don't",
                      style: GoogleFonts.poppins(
                        color: !isYesSelected
                            ? AppColor.buttonColor
                            : AppColor.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}