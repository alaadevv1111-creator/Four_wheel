import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeProfileInfoCard extends StatelessWidget {
  final String phoneNumber;
  final String emailAddress;

  const EmployeeProfileInfoCard({
    super.key,
    required this.phoneNumber,
    required this.emailAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBlock(
            title: 'PHONE NUMBER',
            value: phoneNumber,
            isPhone: true,
          ),

          SizedBox(height: 32.h),

          _infoBlock(
            title: 'EMAIL ADDRESS',
            value: emailAddress,
            isPhone: false,
          ),
        ],
      ),
    );
  }

  Widget _infoBlock({
    required String title,
    required String value,
    required bool isPhone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: const Color(0xff45464D),
          ),
        ),

        SizedBox(height: 12.h),

        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff191C1E),
            ),
          ),
        ),
      ],
    );
  }
}