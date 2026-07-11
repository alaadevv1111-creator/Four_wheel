import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/controller/user_ordercontroller.dart';
import 'package:four_wheels/models/service_ordermodel.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/services/Booking_service.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final ServiceOrderModel order;

  const ServiceRequestDetailsScreen({
    super.key,
    required this.order,
  });

  bool get _isCompleted {
    final status = order.status.toLowerCase().trim();
    return status == 'completed' || status.contains('complete');
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
        title: Text(
          'Service Request Details',
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(26.w, 18.h, 26.w, 120.h),
        children: [
          _requestHeaderCard(),

          SizedBox(height: 18.h),

          _serviceTypeCard(),

          SizedBox(height: 18.h),

          Row(
            children: [
              Expanded(
                child: _smallCard(
                  title: 'LOCATION',
                  icon: Icons.location_on_outlined,
                  value: order.location.isEmpty ? '-' : order.location,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _smallCard(
                  title: 'APPOINTMENT',
                  icon: Icons.calendar_month_outlined,
                  value: '${order.date}\n${order.time}',
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          _reportedIssueCard(),

          SizedBox(height: 20.h),
          _buildMechanicRating(order),

          SizedBox(height: 20.h),

          _cancellationCard(),
        ],
      ),
      bottomNavigationBar: _canCancel
          ? Container(
        padding: EdgeInsets.fromLTRB(26.w, 18.h, 26.w, 28.h),
        color: const Color(0xffF8FAFC),
        child: CustomButton(
          text: 'Cancel Order',
          textcolor: Colors.white,
          height: 58.h,
          gradient: AppColor.primaryGradient,
          fontwight: FontWeight.w900,
          fontsize: 16.sp,
          onTap: () {
            controller.showCancelServiceAlert(order.id);
          },
        ),
      )
          : null,
    );
  }

  Widget _requestHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SERVICE REQUEST ID',
                  style: GoogleFonts.manrope(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff94A3B8),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  order.requestNumber,
                  style: GoogleFonts.manrope(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16.sp,
                      color: const Color(0xff64748B),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'Requested on ${order.date}',
                        style: GoogleFonts.manrope(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _statusBadge(order.status),
        ],
      ),
    );
  }

  Widget _serviceTypeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SERVICE TYPE',
            style: GoogleFonts.manrope(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xff94A3B8),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF1F5F9),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.build_rounded,
                  color: const Color(0xff101828),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  order.serviceName,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 120.h,
      ),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xff94A3B8),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: const Color(0xff64748B),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff101828),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportedIssueCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 20.sp,
                color: const Color(0xff101828),
              ),
              SizedBox(width: 8.w),
              Text(
                'REPORTED ISSUE',
                style: GoogleFonts.manrope(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff94A3B8),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            order.problemDescription.isEmpty
                ? 'No issue description provided.'
                : order.problemDescription,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              height: 1.55,
              fontWeight: FontWeight.w600,
              color: const Color(0xff334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: const Color(0xff64748B),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff334155),
          ),
        ),
      ],
    );
  }

  Widget _mechanicAvatar() {
    final path = order.mechanicImage.trim();

    if (path.isEmpty) {
      return CircleAvatar(
        radius: 28.r,
        backgroundColor: const Color(0xffE5E7EB),
        child: Icon(
          order.mechanicName.trim().isEmpty
              ? Icons.person_outline
              : Icons.person,
          color: const Color(0xff64748B),
        ),
      );
    }

    if (path.startsWith('http')) {
      return CircleAvatar(
        radius: 28.r,
        backgroundColor: const Color(0xffE5E7EB),
        backgroundImage: NetworkImage(path),
      );
    }

    return CircleAvatar(
      radius: 28.r,
      backgroundColor: const Color(0xffE5E7EB),
      backgroundImage: NetworkImage(
        'https://reload-hug-monastery.ngrok-free.dev/storage/$path',
      ),
    );
  }

  Widget _cancellationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Service Cancellation',
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
              ),
              Icon(
                Icons.delete_outline_rounded,
                color: const Color(0xffDC2626),
                size: 22.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Service requests may only be cancelled within 24 hours of placement.',
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: const Color(0xff64748B),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 46.h,
            decoration: BoxDecoration(
              color: const Color(0xffFFF1F2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                '12 Hours Remaining',
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xffEF4444),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMechanicRating(ServiceOrderModel order) {
    final UserOrdersController controller = Get.find<UserOrdersController>();

    print('🔍 RATING CARD RENDERED - Order ID: ${order.id} - Mechanic: ${order.mechanicName}');

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1.5),
      ),
      child: Obx(() {
        final rated = controller.ratedServiceOrders[order.id];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate the Mechanic',
              style: GoogleFonts.manrope(
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),

            SizedBox(height: 9.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (i) {
                final star = i + 1;
                final active = rated != null && star <= rated;

                final icon = Icon(
                  Icons.star,
                  size: 32.sp,
                  color: active ? const Color(0xffFBBF24) : const Color(0xffCBD5E1),
                );

                if (rated != null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: icon,
                  );
                }

                return GestureDetector(
                  onTap: () {
                    controller.ratedServiceOrders[order.id] = star;
                    BookingService.rateServiceOrder(id: order.id, rating: star);
                    Get.snackbar('Success', 'Rating saved!');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: icon,
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _statusBadge(String status) {
    final value = status.toLowerCase().trim();

    String text = 'Under Review';

    if (value == 'pending') {
      text = 'Under Review';
    } else if (value == 'in progress' || value == 'active') {
      text = 'In Progress';
    } else if (value == 'completed') {
      text = 'Completed';
    } else if (value == 'rejected') {
      text = 'Rejected';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xff101828),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MechanicRatingStars extends StatelessWidget {
  final String orderId;
  const _MechanicRatingStars({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final UserOrdersController controller = Get.find<UserOrdersController>();

    return Obx(() {
      final rated = controller.ratedServiceOrders[orderId];

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
                'Rate the mechanic',
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
                    controller.ratedServiceOrders[orderId] = star;
                    BookingService.rateServiceOrder(id: orderId, rating: star);
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