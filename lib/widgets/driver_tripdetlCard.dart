import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/custom_ratingstars.dart';

class DriverTripDetailsCard extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final bool showCustomerPhone;
  final String price;
  final String location;
  final String tripDate;
  final int selectedRating;
  final bool canRate;
  final bool alreadyRated;
  final bool ratingExpired;
  final bool isSubmitting;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmitRating;

  const DriverTripDetailsCard({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.showCustomerPhone,
    required this.price,
    required this.location,
    required this.tripDate,
    required this.selectedRating,
    required this.canRate,
    required this.alreadyRated,
    required this.ratingExpired,
    required this.isSubmitting,
    required this.onRatingChanged,
    required this.onSubmitRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff191C1E),
                      ),
                    ),
                    if (showCustomerPhone) ...[
                      SizedBox(height: 4.h),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          customerPhone,
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            color: const Color(0xff191C1E),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PRICE',
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff45464D),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    price,
                    style: GoogleFonts.manrope(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 26.h),
          Row(
            children: [
              Expanded(
                child: _detailItem(
                  title: 'Location',
                  value: location,
                ),
              ),
              Expanded(
                child: _detailItem(
                  title: 'Trip Date',
                  value: tripDate,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const Divider(
            height: 1,
            color: Color(0xffF1F5F9),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  _ratingText(),
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff45464D),
                  ),
                ),
              ),
              CustomRatingStars(
                rating: selectedRating.toDouble(),
                enabled: canRate,
                size: 24,
                onChanged: onRatingChanged,
              ),
            ],
          ),
          if (canRate && selectedRating > 0) ...[
            SizedBox(height: 18.h),
            CustomButton(
              text: isSubmitting ? 'Submitting...' : 'Submit Rating',
              textcolor: Colors.white,
              color: isSubmitting
                  ? const Color(0xffCBD5E1)
                  : const Color(0xff111827),
              height: 50.h,
              fontwight: FontWeight.w700,
              fontsize: 15.sp,
              onTap: isSubmitting ? () {} : onSubmitRating,
            ),
          ],
        ],
      ),
    );
  }

  String _ratingText() {
    if (alreadyRated) return 'Trip rating submitted';
    if (ratingExpired) return 'Rating period expired';
    if (!canRate) return 'Available after trip completion';
    return 'Rate trip completion';
  }

  Widget _detailItem({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            color: const Color(0xff64748B),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff191C1E),
          ),
        ),
      ],
    );
  }
}