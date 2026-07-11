import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RentalRequirementsCard extends StatelessWidget {
  final List<String> requirements;

  const RentalRequirementsCard({
    super.key,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(28.w, 56.h, 28.w, 0),
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: const Color(0xffF1F2F4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xffD1D5DB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                size: 28.sp,
                color: Colors.black,
              ),
              SizedBox(width: 10.w),
              Text(
                'Rental Requirements',
                style: GoogleFonts.manrope(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff191C1E),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ...requirements.map(
                (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18.sp,
                    color: const Color(0xff16A34A),
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff45464D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}