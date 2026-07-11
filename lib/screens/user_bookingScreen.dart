import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/controller/user_ordercontroller.dart';

import 'package:four_wheels/widgets/user_bottomNavBar.dart';
import 'package:four_wheels/widgets/user_ordertabs.dart';
import 'package:four_wheels/widgets/order_statustabs.dart';
import 'package:four_wheels/widgets/user_rentelcar.dart';
import 'package:four_wheels/widgets/user_orderaccissorycard.dart';
import 'package:four_wheels/widgets/service_ordercard.dart';
import 'package:four_wheels/widgets/service_ordernote.dart';

import 'package:four_wheels/screens/car_rental_order_details_screen.dart';
import 'package:four_wheels/screens/accessory_order_details_screen.dart';
import 'package:four_wheels/screens/service_requestdetiles.dart';
import 'package:four_wheels/models/user_accisorryorder.dart';
import 'package:four_wheels/screens/user_notifiscree.dart';

class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final UserOrdersController controller =
    Get.isRegistered<UserOrdersController>()
        ? Get.find<UserOrdersController>()
        : Get.put(UserOrdersController(), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUserAccessoryOrders();
    });

    final UserDashboardController navController = Get.find<UserDashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'My Orders',
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff101828),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 22.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const UserNotificationsScreen()),
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: const Color(0xff101828),
                  size: 29.sp,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        final bool isCarRental =
            controller.selectedCategoryIndex.value == 0;
        final bool isAccessories =
            controller.selectedCategoryIndex.value == 1;
        final bool isServices =
            controller.selectedCategoryIndex.value == 2;

        final accessoryOrders = controller.filteredUserAccessoryOrders;

        final rentalOrders = controller.filteredOrders;
        final serviceOrders = controller.filteredServiceOrders;

        return ListView(
          padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 130.h),
          children: [
            UserOrderTabs(
              tabs: controller.categoryTabs,
              selectedIndex: controller.selectedCategoryIndex.value,
              onChanged: controller.changeCategory,
            ),

            SizedBox(height: 34.h),

            UserOrderStatusTabs(
              tabs: controller.statusTabs,
              selectedIndex: controller.selectedStatusIndex.value,
              onChanged: controller.changeStatus,
            ),

            SizedBox(height: 34.h),

            if (controller.isLoading.value)
              Padding(
                padding: EdgeInsets.only(top: 90.h),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (isCarRental) ...[
              if (rentalOrders.isEmpty)
                _emptyOrders()
              else
                ...rentalOrders.map(
                      (order) => Padding(
                    padding: EdgeInsets.only(bottom: 34.h),
                    child: UserRentalOrderCard(
                      carImage: order.carImage,
                      carName: order.carName,
                      rentalId: order.rentalId,
                      totalPrice: order.totalPrice,
                      pickupDate: order.pickupDate,
                      pickupTime: order.pickupTime,
                      returnDate: order.returnDate,
                      returnTime: order.returnTime,
                      onViewDetailsTap: () {
                        Get.to(
                              () => CarRentalOrderDetailsScreen(order: order),
                        );
                      },
                    ),
                  ),
                ),
            ]

            else if (isAccessories) ...[
              if (accessoryOrders.isEmpty)
                _emptyOrders()
              else
                ...accessoryOrders.map(
                      (order) => Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: AccessoryOrderCard(
                      image: order.accessoryImage,
                      orderNumber: '#${order.id}',
                      accessoryName: order.accessoryName,
                      orderDate: order.createdAt,
                      price: '\$${order.totalPrice}',
                      onViewDetails: () {
                        Get.to(
                              () => AccessoryOrderDetailsScreen(order: order),
                        );
                      },
                    ),
                  ),
                ),

            ] else if (isServices) ...[
              const ServiceOrderNoticeCard(),

              SizedBox(height: 24.h),

              if (serviceOrders.isEmpty)
                _emptyOrders()
              else
                ...serviceOrders.map(
                      (order) => Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: ServiceOrderCard(
                      requestNumber: order.requestNumber,
                      serviceName: order.serviceName,
                      date: order.date,
                      time: order.time,
                      location: order.location,
                      status: order.status,
                      onDetailsTap: () {
                        Get.to(
                              () => ServiceRequestDetailsScreen(order: order),
                        );
                      },
                      onCancelTap: () {
                        controller.showCancelServiceAlert(order.id);
                      },
                    ),
                  ),
                ),
            ] else ...[
              _emptyOrders(),
            ],
          ],
        );
      }),

      bottomNavigationBar: Obx(
            () => UserBottomNavBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeIndex,
        ),
      ),
    );
  }

  Widget _emptyOrders() {
    return Padding(
      padding: EdgeInsets.only(top: 90.h),
      child: Center(
        child: Text(
          'No orders found',
          style: GoogleFonts.manrope(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff64748B),
          ),
        ),
      ),
    );
  }
}