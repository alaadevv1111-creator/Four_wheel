import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/utils/image_uelper.dart';
import 'package:four_wheels/constants/colors.dart';

class UserRentalOrderCard extends StatelessWidget {
  final String carImage;
  final String carName;
  final String rentalId;
  final String totalPrice;
  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;
  final VoidCallback onViewDetailsTap;

  const UserRentalOrderCard({
    super.key,
    required this.carImage,
    required this.carName,
    required this.rentalId,
    required this.totalPrice,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 168.h,
            width: double.infinity,
            child: _carImage(),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            carName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Rental ID: $rentalId',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'TOTAL',
                            style: GoogleFonts.manrope(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff64748B),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              totalPrice,
                              style: GoogleFonts.manrope(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xff101828),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F3F6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _dateItem(
                          title: 'PICKUP',
                          date: pickupDate,
                          time: pickupTime,
                        ),
                      ),
                      Container(
                        width: 1.w,
                        height: 44.h,
                        color: const Color(0xffD9DEE8),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 18.w),
                          child: _dateItem(
                            title: 'RETURN',
                            date: returnDate,
                            time: returnTime,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                GestureDetector(
                  onTap: onViewDetailsTap,
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'View Details',
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateItem({
    required String title,
    required String date,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff475569),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          date,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
        Text(
          time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
      ],
    );
  }

  Widget _carImage() {
    final image = carImage.trim();

    if (image.isEmpty || image == 'null') {
      return _placeholder();
    }

    return Image.network(
      ImageHelper.resolveServerUrl(image),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xffE5E7EB),
      child: Center(
        child: Icon(
          Icons.directions_car,
          size: 54.sp,
          color: const Color(0xff94A3B8),
        ),
      ),
    );
  }
}