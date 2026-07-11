import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:four_wheels/controller/user_ordercontroller.dart';
import 'package:four_wheels/controller/request_mechaniccontroller.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:four_wheels/widgets/admin_notifiPop.dart';
import 'package:four_wheels/models/user_ordermodel.dart';
import 'package:four_wheels/models/service_requestordermodel.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/user_ordertabs.dart';
import 'package:four_wheels/widgets/order_statustabs.dart';
import 'package:four_wheels/widgets/custom_Rentals_Info.dart';
import 'package:four_wheels/widgets/user_orderaccissorycard.dart';
import 'package:four_wheels/widgets/service_ordercard.dart';
import 'package:four_wheels/screens/admin_rentilsdetilesservice.dart';
import 'package:four_wheels/controller/admin_bookingcontroller.dart';
import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/ProfileAvatar.dart';
import 'package:four_wheels/screens/Profile_admin_sitting.dart';
import 'package:four_wheels/screens/General_admin_sitting.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class RentalsScreen extends StatelessWidget {
  const RentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminBookingController Acontroller =
    Get.isRegistered<AdminBookingController>()
        ? Get.find<AdminBookingController>()
        : Get.put(AdminBookingController());

    final UserOrdersController controller =
    Get.isRegistered<UserOrdersController>()
        ? Get.find<UserOrdersController>()
        : Get.put(UserOrdersController(), permanent: true);

    final RequestMechanicController requestController =
    Get.isRegistered<RequestMechanicController>()
        ? Get.find<RequestMechanicController>()
        : Get.put(RequestMechanicController(), permanent: true);

    final DashbordController dashboardController =
    Get.isRegistered<DashbordController>()
        ? Get.find<DashbordController>()
        : Get.put(DashbordController(), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.currentIndex.value = 1;
    });

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 55.h,
        titleSpacing: 18.w,
        title: Row(
          children: [
            SizedBox(width: 10.w),
            Text(
              'Rentals',
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),
          ],
        ),
        actions: [
          AdminNotificationBell(
            initialType: 'employees',
            showFilters: false,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final selectedCategory = controller.selectedCategoryIndex.value;

        return ListView(
          padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 130.h),
          children: [
            if (selectedCategory == 2) ...[
              CustomInfoCard(
                title: 'Pending Services',
                value: requestController.adminPendingRequests.length.toString(),
                footerText: 'Waiting for approval',
                icon: Icons.pending_actions_outlined,
              ),
              SizedBox(height: 18.h),
              CustomInfoCard(
                title: 'In Progress Services',
                value: requestController.adminActiveRequests.length.toString(),
                footerText: 'Currently in progress',
                icon: Icons.build_circle_outlined,
              ),
              SizedBox(height: 18.h),
              CustomInfoCard(
                title: 'Completed Services',
                value: requestController.adminCompletedRequests.length.toString(),
                footerText: 'Finished service orders',
                icon: Icons.check_circle_outline,
                gradient: const LinearGradient(
                  colors: [Color(0xff111827), Color(0xff334155)],
                ),
                titleColor: Colors.white,
                valueColor: Colors.white,
                footerColor: Colors.white70,
                iconColor: Colors.white,
              ),
            ] else if (selectedCategory == 1) ...[
              CustomInfoCard(
                title: 'Pending Accessories',
                value: controller.adminAccessoryOrders
                    .where((o) => o.status.toLowerCase() == 'pending')
                    .length
                    .toString(),
                footerText: 'Waiting for approval',
                icon: Icons.pending_actions_outlined,
              ),
              SizedBox(height: 18.h),
              CustomInfoCard(
                title: 'Active Accessories',
                value: controller.adminAccessoryOrders
                    .where((o) => o.status.toLowerCase() == 'active')
                    .length
                    .toString(),
                footerText: 'Currently in progress',
                icon: Icons.build_circle_outlined,
              ),
              SizedBox(height: 18.h),
              CustomInfoCard(
                title: 'Completed Accessories',
                value: controller.adminAccessoryOrders
                    .where((o) => o.status.toLowerCase() == 'completed')
                    .length
                    .toString(),
                footerText: 'Finished accessory orders',
                icon: Icons.check_circle_outline,
                gradient: const LinearGradient(
                  colors: [Color(0xff111827), Color(0xff334155)],
                ),
                titleColor: Colors.white,
                valueColor: Colors.white,
                footerColor: Colors.white70,
                iconColor: Colors.white,
              ),
            ] else ...[
              CustomInfoCard(
                title: 'Pending Rentals',
                value: Acontroller.pendingBookings.length.toString(),
                footerText: 'Waiting for approval',
                icon: Icons.pending_actions_outlined,
              ),
              SizedBox(height: 18.h),
              CustomInfoCard(
                title: 'Active Rentals',
                value: Acontroller.activeBookings.length.toString(),
                footerText: 'Currently in progress',
                icon: Icons.directions_car_outlined,
              ),
              SizedBox(height: 18.h),
              CustomInfoCard(
                title: 'Completed',
                value: Acontroller.completedBookings.length.toString(),
                footerText: 'Finished rental orders',
                icon: Icons.check_circle_outline,
                gradient: const LinearGradient(
                  colors: [Color(0xff111827), Color(0xff334155)],
                ),
                titleColor: Colors.white,
                valueColor: Colors.white,
                footerColor: Colors.white70,
                iconColor: Colors.white,
              ),
            ],

            SizedBox(height: 42.h),

            Row(
              children: [
                Text(
                  'All Orders',
                  style: GoogleFonts.manrope(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Filter',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff52617A),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.filter_list, size: 18.sp, color: const Color(0xff52617A)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 22.h),

            UserOrderTabs(
              tabs: controller.categoryTabs,
              selectedIndex: controller.selectedCategoryIndex.value,
              onChanged: (index) {
                controller.changeCategory(index);
                if (index == 2) {
                  requestController.loadAllAdminRequests();
                }
              },
            ),

            SizedBox(height: 24.h),

            if (selectedCategory == 0)
              Obx(
                    () => Row(
                  children: List.generate(Acontroller.tabs.length, (index) {
                    final selected = Acontroller.selectedTabIndex.value == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => Acontroller.changeTab(index),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xff101828) : const Color(0xffF1F3F5),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Center(
                            child: Text(
                              Acontroller.tabs[index],
                              style: TextStyle(
                                color: selected ? Colors.white : const Color(0xff64748B),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            else
              UserOrderStatusTabs(
                tabs: controller.statusTabs,
                selectedIndex: controller.selectedStatusIndex.value,
                onChanged: (index) {
                  controller.changeStatus(index);
                  if (selectedCategory == 2) {
                    requestController.loadAllAdminRequests();
                  }
                },
              ),

            SizedBox(height: 28.h),

            // =========================== CAR RENTALS ===========================
            if (selectedCategory == 0) ...[
              Obx(() {
                if (Acontroller.isLoading.value) {
                  return Padding(
                    padding: EdgeInsets.only(top: 90.h),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final bookings = Acontroller.currentBookings;

                if (bookings.isEmpty) {
                  return _emptyOrders('No rental orders found');
                }

                return Column(
                  children: bookings.map((booking) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 18.h),
                      child: _carRentalCard(
                        booking: booking,
                        onAccept: () => Acontroller.approveBooking(booking.id),
                        onComplete: () => Acontroller.completeBooking(booking.id),
                        onDelete: () => Acontroller.deleteBooking(booking.id),
                      ),
                    );
                  }).toList(),
                );
              }),
            ]

            // =========================== ACCESSORIES ===========================
            else if (selectedCategory == 1) ...[
              Obx(() {
                if (controller.isLoading.value) {
                  return Padding(
                    padding: EdgeInsets.only(top: 90.h),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final filteredAccessory = controller.filteredAccessoryOrders;

                if (filteredAccessory.isEmpty) {
                  return _emptyOrders('No accessory orders found');
                }

                return Column(
                  children: filteredAccessory.map((order) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 18.h),
                      child: _accessoryOrderCardV2(
                        order: order,
                        onAccept: () => controller.acceptAccessoryOrder(order.id),
                        onComplete: () => controller.completeAccessoryOrder(order.id),
                        onDelete: () => controller.showDeleteAccessoryOrderAlert(order.id),
                      ),
                    );
                  }).toList(),
                );
              }),
            ]

            // =========================== SERVICES ===========================
            else if (selectedCategory == 2) ...[
                Obx(() {
                  final apiStatus = _serviceApiStatus(controller.selectedStatusIndex.value);
                  final requests = _serviceRequestsByStatus(requestController, apiStatus);

                  if (requestController.isLoading.value) {
                    return Padding(
                      padding: EdgeInsets.only(top: 90.h),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (requests.isEmpty) {
                    return _emptyOrders('No service orders found');
                  }

                  return Column(
                    children: requests.map((request) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 18.h),
                        child: _serviceOrderCardV2(
                          request: request,
                          onAccept: () => requestController.openAcceptDialog(request),
                          onDelete: () => requestController.deleteAdminServiceRequest(request),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
          ],
        );
      }),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: dashboardController.currentIndex.value,
          onTap: dashboardController.changeIndex,
        ),
      ),
    );
  }

  Widget _carRentalCard({
    required DriverBookingTaskModel booking,
    required VoidCallback onAccept,
    required VoidCallback onComplete,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: () => _showCarRentalDetailsDialog(booking),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: _buildApiImage(booking.carImage),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '#${booking.id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xff101828),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _statusBadge(booking.status),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        booking.carName.isEmpty ? 'Car Rental' : booking.carName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 15.5.sp,
                          height: 1.25,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff101828),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        booking.customerName.isEmpty ? 'Customer User' : booking.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14.sp, color: const Color(0xff64748B)),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${booking.bookingDate} - ${booking.endDate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff64748B),
                    ),
                  ),
                ),
                Text(
                  '\$${booking.price}',
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),
            const Divider(height: 1, color: Color(0xffE5E7EB)),
            SizedBox(height: 12.h),

            _adminActionButtons(
              status: booking.status,
              onAccept: onAccept,
              onComplete: onComplete,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  void _showCarRentalDetailsDialog(DriverBookingTaskModel booking) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(22.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rental #${booking.id}',
                      style: GoogleFonts.manrope(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff101828),
                      ),
                    ),
                  ),
                  _statusBadge(booking.status),
                ],
              ),
              SizedBox(height: 16.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: SizedBox(
                  width: double.infinity,
                  height: 140.h,
                  child: _buildApiImage(booking.carImage),
                ),
              ),
              SizedBox(height: 16.h),
              _detailRow('Vehicle', booking.carName.isEmpty ? '-' : booking.carName),
              _detailRow('Customer', booking.customerName.isEmpty ? '-' : booking.customerName),
              _detailRow('Phone', booking.customerPhone.isEmpty ? '-' : booking.customerPhone),
              _detailRow('Driver', booking.driverName.isEmpty ? 'Not assigned' : booking.driverName),
              _detailRow('Pickup Location', booking.pickupLocation.isEmpty ? '-' : booking.pickupLocation),
              _detailRow('Start Date', booking.bookingDate),
              _detailRow('End Date', booking.endDate),
              _detailRow('Total Price', '\$${booking.price}'),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff111827),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      'Close',
                      style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accessoryOrderCardV2({
    required dynamic order,
    required VoidCallback onAccept,
    required VoidCallback onComplete,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: () => _showAccessoryDetailsDialogV2(order, onComplete, onDelete),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: _buildAccessoryImage(order.accessoryImage),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '#${order.id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xff101828),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _statusBadge(order.status),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        order.accessoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 15.5.sp,
                          height: 1.25,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff101828),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        order.fullName.isEmpty ? 'Customer User' : order.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Text(
                  'Qty: ${order.quantity}',
                  style: GoogleFonts.manrope(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff94A3B8),
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${order.totalPrice}',
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),
            const Divider(height: 1, color: Color(0xffE5E7EB)),
            SizedBox(height: 12.h),

            _adminActionButtons(
              status: order.status,
              onAccept: onAccept,
              onComplete: onComplete,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccessoryDetailsDialogV2(
      dynamic order,
      VoidCallback onComplete,
      VoidCallback onDelete,
      ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(22.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      width: 46.w,
                      height: 46.h,
                      child: _buildAccessoryImage(order.accessoryImage),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      order.accessoryName,
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff101828),
                      ),
                    ),
                  ),
                  _statusBadge(order.status),
                ],
              ),
              SizedBox(height: 18.h),
              _detailRow('Order #', '#${order.id}'),
              _detailRow('Quantity', order.quantity.toString()),
              _detailRow('Unit Price', '\$${(double.tryParse(order.totalPrice) ?? 0) / (order.quantity == 0 ? 1 : order.quantity)}'),
              _detailRow('Total', '\$${order.totalPrice}'),
              _detailRow('Order Date', order.createdAt),
              SizedBox(height: 10.h),
              Text(
                'DELIVERY DETAILS',
                style: GoogleFonts.manrope(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff94A3B8),
                ),
              ),
              SizedBox(height: 8.h),
              _detailRow('Full Name', order.fullName),
              _detailRow('Phone', order.phone),
              _detailRow('Address', '${order.address}, ${order.city}'),
              if (order.notes.isNotEmpty) _detailRow('Notes', order.notes),
              SizedBox(height: 20.h),
              Row(
                children: [
                  if (order.status.toString().toLowerCase() != 'completed')
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          onComplete();
                        },
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffDBEAFE),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'Mark Delivered',
                              style: GoogleFonts.manrope(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xff2563EB),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        onDelete();
                      },
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffFEE2E2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'Delete',
                            style: GoogleFonts.manrope(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xffDC2626),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff111827),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Close',
                      style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceOrderCardV2({
    required ServiceRequestModel request,
    required VoidCallback onAccept,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: () => _showServiceDetailsDialogV2(request, onAccept, onDelete),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46.w,
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F5F9),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: const Icon(Icons.build_outlined, color: Color(0xff334155)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${request.id}',
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff94A3B8),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        request.serviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff101828),
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(request.status),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined, size: 14.sp, color: const Color(0xff64748B)),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${request.date} • ${request.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff64748B),
                    ),
                  ),
                ),
              ],
            ),
            if (request.location.trim().isNotEmpty) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14.sp, color: const Color(0xff64748B)),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      request.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (request.isPending) ...[
              SizedBox(height: 14.h),
              const Divider(height: 1, color: Color(0xffE5E7EB)),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _adminButton(
                      text: 'Accept',
                      icon: Icons.check_circle_outline,
                      color: const Color(0xffDCFCE7),
                      textColor: const Color(0xff15803D),
                      onTap: onAccept,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _adminButton(
                      text: 'Delete',
                      icon: Icons.delete_outline,
                      color: const Color(0xffFEE2E2),
                      textColor: const Color(0xffDC2626),
                      onTap: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showServiceDetailsDialogV2(
      ServiceRequestModel request,
      VoidCallback onAccept,
      VoidCallback onDelete,
      ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(22.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${request.id}',
                      style: GoogleFonts.manrope(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff101828),
                      ),
                    ),
                  ),
                  _statusBadge(request.status),
                ],
              ),
              SizedBox(height: 16.h),
              _detailRow('Service', request.serviceName),
              _detailRow('Vehicle', request.vehicleModel.isEmpty ? 'Not Specified' : request.vehicleModel),
              _detailRow('Date', request.date),
              _detailRow('Time', request.time),
              _detailRow('Location', request.location.isEmpty ? '-' : request.location),
              SizedBox(height: 10.h),
              Text(
                'ISSUE DESCRIPTION',
                style: GoogleFonts.manrope(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff94A3B8),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  request.problemDescription.isEmpty
                      ? 'No description provided.'
                      : request.problemDescription,
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff64748B),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (request.isPending)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          onAccept();
                        },
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffDCFCE7),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'Accept',
                              style: GoogleFonts.manrope(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xff15803D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          onDelete();
                        },
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffFEE2E2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.manrope(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xffDC2626),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff111827),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Close',
                      style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApiImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 68.w,
        height: 68.h,
        fit: BoxFit.cover,
        headers: const {'ngrok-skip-browser-warning': 'true'},
        errorBuilder: (context, error, stackTrace) => _apiImagePlaceholder(),
      );
    }
    if (image.isNotEmpty) {
      return Image.file(
        File(image),
        width: 68.w,
        height: 68.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _apiImagePlaceholder(),
      );
    }
    return _apiImagePlaceholder();
  }

  Widget _apiImagePlaceholder() {
    return Container(
      width: 68.w,
      height: 68.h,
      color: const Color(0xffE5E7EB),
      child: Icon(Icons.directions_car_filled_outlined, color: const Color(0xff94A3B8), size: 30.sp),
    );
  }

  Widget _buildAccessoryImage(String image) {
    if (ImageHelper.isEmpty(image)) {
      return _accessoryPlaceholder();
    }

    if (ImageHelper.isLocalFile(image)) {
      return Image.file(
        File(image),
        width: 68.w,
        height: 68.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _accessoryPlaceholder(),
      );
    }

    return Image.network(
      ImageHelper.resolveServerUrl(image),
      width: 68.w,
      height: 68.h,
      fit: BoxFit.cover,
      headers: const {'ngrok-skip-browser-warning': 'true'},
      errorBuilder: (_, __, ___) => _accessoryPlaceholder(),
    );
  }

  Widget _accessoryPlaceholder() {
    return Container(
      width: 68.w,
      height: 68.h,
      color: const Color(0xffE5E7EB),
      child: Icon(Icons.inventory_2_outlined, color: const Color(0xff94A3B8), size: 30.sp),
    );
  }

  Widget _statusBadge(String status) {
    final lowerStatus = status.trim().toLowerCase();
    Color bgColor;
    Color textColor;

    if (lowerStatus == 'pending') {
      bgColor = const Color(0xffFEF3C7);
      textColor = const Color(0xffD97706);
    } else if (lowerStatus == 'in progress' ||
        lowerStatus == 'inprogress' ||
        lowerStatus == 'active') {
      bgColor = const Color(0xffDBEAFE);
      textColor = const Color(0xff2563EB);
    } else {
      bgColor = const Color(0xffDCFCE7);
      textColor = const Color(0xff15803D);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(18.r)),
      child: Text(
        status,
        style: GoogleFonts.manrope(fontSize: 11.sp, fontWeight: FontWeight.w900, color: textColor),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xff64748B)),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.manrope(fontSize: 13.sp, fontWeight: FontWeight.w900, color: const Color(0xff101828)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyOrders(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 90.h),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xff64748B)),
        ),
      ),
    );
  }

  Widget _adminActionButtons({
    required String status,
    required VoidCallback onAccept,
    required VoidCallback onComplete,
    required VoidCallback onDelete,
  }) {
    final lowerStatus = status.trim().toLowerCase();
    final isPending = lowerStatus == 'pending';
    final isInProgress = lowerStatus == 'active';
    final isCompleted = lowerStatus == 'completed';

    return Row(
      children: [
        if (isPending)
          Expanded(
            child: _adminButton(
              text: 'Accept',
              icon: Icons.check_circle_outline,
              color: const Color(0xffDCFCE7),
              textColor: const Color(0xff15803D),
              onTap: onAccept,
            ),
          ),
        if (isInProgress)
          Expanded(
            child: _adminButton(
              text: 'Complete',
              icon: Icons.done_all,
              color: const Color(0xffDBEAFE),
              textColor: const Color(0xff2563EB),
              onTap: onComplete,
            ),
          ),
        if (!isCompleted) ...[
          SizedBox(width: 12.w),
          Expanded(
            child: _adminButton(
              text: 'Delete',
              icon: Icons.delete_outline,
              color: const Color(0xffFEE2E2),
              textColor: const Color(0xffDC2626),
              onTap: onDelete,
            ),
          ),
        ],
      ],
    );
  }

  Widget _adminButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: textColor),
            SizedBox(width: 8.w),
            Text(
              text,
              style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w900, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  String _serviceApiStatus(int index) {
    if (index == 0) return 'pending';
    if (index == 1) return 'active';
    return 'completed';
  }

  List<ServiceRequestModel> _serviceRequestsByStatus(
      RequestMechanicController controller,
      String status,
      ) {
    if (status == 'pending') return controller.adminPendingRequests;
    if (status == 'active') return controller.adminActiveRequests;
    return controller.adminCompletedRequests;
  }
}