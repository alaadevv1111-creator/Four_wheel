import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarAdditionalInfoGrid extends StatelessWidget {
  final List<String> items;

  const CarAdditionalInfoGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 52.h, 28.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: GoogleFonts.manrope(
              fontSize: 23.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 22.h),
          GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 14.w,
              childAspectRatio: 3.3,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F2F4),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 22.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        items[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff191C1E),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}