import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportedIssueCard extends StatelessWidget {
  final String issue;

  const ReportedIssueCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30.w, 28.h, 30.w, 28.h),
      decoration: BoxDecoration(
        color: const Color(0xffF1F2F4),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        issue,
        style: GoogleFonts.manrope(
          fontSize: 16.sp,
          height: 1.55,
          fontWeight: FontWeight.normal,
          color: const Color(0xff191C1E),
        ),
      ),
    );
  }
}