import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../models/accessory_model.dart';
import '../widgets/custom_button2.dart';
import 'user_dashboard.dart';

class OrderSuccessScreen extends StatelessWidget {
  final AccessoryModel accessory;
  final String orderDate;

  const OrderSuccessScreen({
    super.key,
    required this.accessory,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cardBg,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                _buildCirclesStack(),
                SizedBox(height: 40.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Order Submitted Successfully",
                    style: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Your accessory order has been successfully received and is currently under review. It will be approved shortly",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    color: const Color(0xFF45464D),
                  ),
                ),
                SizedBox(height: 32.h),
                _buildOrderCard(orderDate),
                SizedBox(height: 40.h),
                CustomButton(
                  text: "Back To Home",
                  backgroundColor: const Color(0xFFE6E8EA),
                  textColor: const Color(0xFF0F172A),
                  borderRadius: 12,
                  onTap: () => Get.offAll(() => const UserDashboard()),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCirclesStack() => SizedBox(
    width: 300.r,
    height: 300.r,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 300.r,
          height: 300.r,
          decoration: const BoxDecoration(
            color: Color(0xFFF2F4F6),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 190.r,
          height: 190.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 120.r,
          height: 120.r,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.cardprim2, AppColor.cardprim],
            ),
            shape: BoxShape.circle,
          ),
        ),
        Icon(Icons.check, color: Colors.white, size: 50.r),
      ],
    ),
  );

  Widget _buildOrderCard(String date) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(24.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ORDER NUMBER",
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF45464D),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "#${accessory.partId}",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE7F9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "PANDING",
                style: GoogleFonts.manrope(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4B69A1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("PRODUCT NAME", accessory.name),
                    SizedBox(height: 20.h),
                    _buildDetailItem("ORDER DATE", date),
                    SizedBox(height: 20.h),
                    Text(
                      "PAYMENT METHOD",
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF45464D),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.payments_outlined, size: 18.sp, color: const Color(0xFF45464D)),
                        SizedBox(width: 8.w),
                        Text(
                          "Cash On Delivery",
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildDetailItem(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF45464D),
        ),
      ),
      SizedBox(height: 4.h),
      Text(
        value,
        style: GoogleFonts.manrope(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    ],
  );
}