import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/user_ordercontroller.dart';
import 'package:four_wheels/models/user_accisorryorder.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/services/Booking_service.dart';

import 'package:four_wheels/widgets/accessory_details_product_card.dart';
import 'package:four_wheels/widgets/accessory_ordersummry.dart';
import 'package:four_wheels/widgets/accessory_paymentdetiles.dart';
import 'package:four_wheels/widgets/accessory_cancellation.dart';

class AccessoryOrderDetailsScreen extends StatelessWidget {
  final UserAccessoryOrderModel order;

  const AccessoryOrderDetailsScreen({
    super.key,
    required this.order,
  });

  String get _unitPrice {
    final total = double.tryParse(order.totalPrice) ?? 0;
    final qty = order.quantity == 0 ? 1 : order.quantity;
    return (total / qty).toStringAsFixed(2);
  }

  String get _paymentStatusText {
    final status = order.status.toLowerCase();
    if (status == 'completed') return 'PAID';
    if (status == 'rejected') return 'CANCELLED';
    return 'PENDING PAYMENT';
  }

  bool get _canCancel {
    final status = order.status.toLowerCase();
    return status == 'pending';
  }

  bool get _isCompleted {
    return order.status.toLowerCase() == 'completed';
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
              'Accessory Details',
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),
            Text(
              '#${order.id}',
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
              height: 44.h,
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
        padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 120.h),
        children: [
          AccessoryDetailsProductCard(
            image: order.accessoryImage,
            accessoryName: order.accessoryName,
            category: 'Accessories',
            orderNumber: '#${order.id}',
            status: order.status,
          ),
          SizedBox(height: 24.h),
          AccessoryOrderSummaryCard(
            orderId: '#${order.id}',
            orderDate: order.createdAt,
            quantity: 'x${order.quantity}',
            unitPrice: '\$$_unitPrice',
            totalAmount: '\$${order.totalPrice}',
          ),
          SizedBox(height: 24.h),
          AccessoryPaymentDetailsCard(
            method: 'Cash On Delivery',
            status: _paymentStatusText,
          ),
          SizedBox(height: 24.h),
          const AccessoryCancellationCard(),
          if (_isCompleted) ...[
            SizedBox(height: 24.h),
            _AccessoryRatingStars(orderId: order.id),
          ],
        ],
      ),
      bottomNavigationBar: _canCancel
          ? Container(
        padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
        color: const Color(0xffF8FAFC),
        child: CustomButton(
          text: 'Cancel Order',
          textcolor: Colors.white,
          height: 58.h,
          color: const Color(0xff334155),
          fontwight: FontWeight.w900,
          fontsize: 16.sp,
          onTap: () {
            controller.showCancelUserAccessoryAlert(order.id);
          },
        ),
      )
          : null,
    );
  }
}

class _AccessoryRatingStars extends StatelessWidget {
  final String orderId;
  const _AccessoryRatingStars({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final UserOrdersController controller = Get.find<UserOrdersController>();

    return Obx(() {
      final rated = controller.ratedAccessoryOrders[orderId];

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
                'Rate this accessory',
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
                    controller.ratedAccessoryOrders[orderId] = star;
                    BookingService.rateAccessoryOrder(id: orderId, rating: star);
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