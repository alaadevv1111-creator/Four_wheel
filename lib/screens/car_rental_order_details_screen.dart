import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/controller/user_ordercontroller.dart';
import 'package:four_wheels/models/user_ordermodel.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/services/Booking_service.dart';

import 'package:four_wheels/widgets/car_rental_details_vehicle_card.dart';
import 'package:four_wheels/widgets/car_rental_pickup_return_card.dart';
import 'package:four_wheels/widgets/car_rental_cost_card.dart';
import 'package:four_wheels/widgets/car_rental_location_card.dart';
import 'package:four_wheels/widgets/car_rental_cancellation_card.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarRentalOrderDetailsScreen extends StatelessWidget {
  final UserOrderModel order;

  const CarRentalOrderDetailsScreen({
    super.key,
    required this.order,
  });

  bool get _isCompleted {
    return order.status.toLowerCase() == 'completed';
  }

  bool get _canCancel {
    return order.status.toLowerCase() == 'pending';
  }

  @override
  Widget build(BuildContext context) {
    final UserOrdersController controller = Get.find<UserOrdersController>();

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff101828),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Rental Details',
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),
            Text(
              order.rentalId,
              style: GoogleFonts.manrope(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff64748B),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.w),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),

            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(26.w, 18.h, 26.w, 120.h),
        children: [
          CarRentalDetailsVehicleCard(
            image: order.carImage,
            carName: order.carName,
            rentalId: order.rentalId,
          ),

          SizedBox(height: 24.h),

          CarRentalPickupReturnCard(
            pickupDate: order.pickupDate,
            pickupTime: order.pickupTime,
            returnDate: order.returnDate,
            returnTime: order.returnTime,
          ),

          SizedBox(height: 18.h),

          CarRentalCostCard(
            duration: order.duration.isEmpty ? '-' : order.duration,
            totalCost: order.totalPrice,
          ),

          SizedBox(height: 18.h),

          CarRentalLocationCard(
            location: order.location.isEmpty ? '-' : order.location,
          ),

          SizedBox(height: 18.h),

          const CarRentalCancellationCard(),

          if (_isCompleted) ...[
            SizedBox(height: 18.h),
            _CarRatingStars(
              orderId: order.id,
              label: 'Rate the car',
              isDriverRating: false,
              rateFunction: BookingService.rateCarOrder,
            ),
            SizedBox(height: 18.h),
            _CarRatingStars(
              orderId: order.id,
              label: 'Rate the driver',
              isDriverRating: true,
              rateFunction: BookingService.rateDriverOrder,
            ),
          ],
        ],
      ),
      bottomNavigationBar: _canCancel
          ? Container(
        padding: EdgeInsets.fromLTRB(26.w, 18.h, 26.w, 28.h),
        color: const Color(0xffF8FAFC),
        child: CustomButton(
          text: 'Cancel Booking',
          textcolor: Colors.white,
          height: 58.h,
          gradient: AppColor.primaryGradient,
          fontwight: FontWeight.w900,
          fontsize: 16.sp,
          onTap: () {
            controller.showCancelCarRentalAlert(order.id);
          },
        ),
      )
          : null,
    );
  }
}

class _CarRatingStars extends StatelessWidget {
  final String orderId;
  final String label;
  final bool isDriverRating;
  final Future<Map<String, dynamic>> Function({
  required String id,
  required int rating,
  }) rateFunction;

  const _CarRatingStars({
    required this.orderId,
    required this.label,
    required this.isDriverRating,
    required this.rateFunction,
  });

  @override
  Widget build(BuildContext context) {
    final UserOrdersController controller = Get.find<UserOrdersController>();

    return Obx(() {
      final ratedMap =
      isDriverRating ? controller.ratedDriverOrders : controller.ratedCarOrders;
      final rated = ratedMap[orderId];

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff101828),
                ),
              ),
            ),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                final active = rated != null && star <= rated;
                final icon = Icon(
                  Icons.star,
                  color: active
                      ? const Color(0xffFBBF24)
                      : const Color(0xffCBD5E1),
                  size: 26.sp,
                );
                if (rated != null) return icon;
                return GestureDetector(
                  onTap: () {
                    ratedMap[orderId] = star;
                    rateFunction(id: orderId, rating: star);
                  },
                  child: icon,
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}