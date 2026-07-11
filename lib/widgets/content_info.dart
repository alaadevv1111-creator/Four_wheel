import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';

class ContactInformationCard extends StatelessWidget {
  final String phoneNumber;
  final String workEmail;

  const ContactInformationCard({
    super.key,
    required this.phoneNumber,
    required this.workEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Contact Information",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    color: AppColor.cardprim,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            _infoItem("PHONE NUMBER", phoneNumber),
            SizedBox(height: 16.h),
            _infoItem("WORK EMAIL", workEmail),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 10.sp,
            letterSpacing: 1,
            color: AppColor.bcolorsmalltitle,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 19.sp,
            color: AppColor.primary,
          ),
        ),
      ],
    );
  }
}