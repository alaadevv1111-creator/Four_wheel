import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/custom_title_section.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/screens/Rentels_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/ProfileAvatar.dart';
import 'package:four_wheels/screens/Profile_admin_sitting.dart';
import 'package:four_wheels/screens/General_admin_sitting.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  final DashbordController controller =
  Get.isRegistered<DashbordController>()
      ? Get.find<DashbordController>()
      : Get.put(DashbordController(), permanent: true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.currentIndex.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backchart,
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
              'Four Wheels',
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
            initialType: 'dashboard',
            showFilters: true,
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
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          DashboardTitleSection(
            smallTitle: "FLEET OPERATIONS",
            bigTitle: "Welcome Admin Performance Overview",
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              Text(
                'Recent Rentals',
                style: GoogleFonts.manrope(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff1D1B20),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(() => const RentalsScreen());
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff334155),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Obx(() {
            if (controller.isRecentBookingsLoading.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 35.h),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            final bookings = controller.lastFourRecentBookings;

            if (bookings.isEmpty) {
              return _emptyRecentRentals();
            }

            return Column(
              children: bookings.map((booking) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _recentRentalCard(booking),
                );
              }).toList(),
            );
          }),

          SizedBox(height: 80.h),
        ],
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }

  Widget _recentRentalCard(DriverBookingTaskModel booking) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: booking.carImage.trim().isEmpty
                ? _recentPlaceholder()
                : Image.network(
              ImageHelper.resolveServerUrl(booking.carImage),
              width: 58.w,
              height: 58.h,
              fit: BoxFit.cover,
              headers: const {'ngrok-skip-browser-warning': 'true'},
              errorBuilder: (_, __, ___) => _recentPlaceholder(),
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.carName.isEmpty ? 'Car Rental' : booking.carName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  booking.customerName.isEmpty
                      ? 'Customer'
                      : booking.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff64748B),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  '${booking.bookingDate} - ${booking.endDate}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff94A3B8),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Text(
            '\$${booking.price}',
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentPlaceholder() {
    return Container(
      width: 58.w,
      height: 58.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.directions_car_filled_outlined,
        color: const Color(0xff94A3B8),
      ),
    );
  }

  Widget _emptyRecentRentals() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 32.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.car_rental_outlined,
            size: 38.sp,
            color: const Color(0xff9CA3AF),
          ),
          SizedBox(height: 12.h),
          Text(
            'No recent rentals yet',
            style: GoogleFonts.manrope(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff6B7280),
            ),
          ),
        ],
      ),
    );
  }
}