import 'package:flutter/material.dart';
import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/car_controller.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:four_wheels/services/carService.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/car_infCarddetils.dart';
import 'package:four_wheels/widgets/car_homeIm.dart';

import 'package:four_wheels/screens/Edit_car.dart';
import 'package:four_wheels/screens/cars_screen.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final CarController carController =
  Get.isRegistered<CarController>()
      ? Get.find<CarController>()
      : Get.put(CarController(), permanent: true);

  final DashbordController dashboardController =
  Get.isRegistered<DashbordController>()
      ? Get.find<DashbordController>()
      : Get.put(DashbordController());

  final isDeleting = false.obs;
  final isLoadingDetails = false.obs;

  @override
  void initState() {
    super.initState();

    final car = carController.selectedCar.value;

    if (car != null && car.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadDetails(car.id);
      });
    }
  }

  Future<void> loadDetails(String id) async {
    isLoadingDetails.value = true;

    try {
      await carController.loadCarDetails(id);
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> deleteCar(String id) async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    try {
      final result = await CarService.deleteCar(id);

      if (result['success'] == true) {
        carController.deleteCar(id);

        Get.snackbar(
          'Deleted',
          result['message'] ?? 'Car deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.off(
              () => const CarsScreenScreen(),
          routeName: '/cars',
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? result['massage'] ?? 'Delete car failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backchart,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.secondary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'Car Details',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff111827),
          ),
        ),
        actions: const [
          AdminNotificationBell(
            initialType: 'cars',
            showFilters: false,
          ),
        ],
      ),
      body: Obx(() {
        final car = carController.selectedCar.value;

        if (isLoadingDetails.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (car == null) {
          return Center(
            child: Text(
              'No car selected',
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                color: const Color(0xff6B7280),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarHeroImage(
                imagePath: car.imageUrl,
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.model,
                      style: GoogleFonts.manrope(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff111827),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14.sp,
                          color: statusColor(car.status),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          carStatusText(car.status),
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: statusColor(car.status),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26.h),
                    _priceCard(
                      daily: car.dailyPrice,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: CarInfoCard(
                            icon: 'assets/icons/icoplate.png',
                            label: 'LICENSE PLATE',
                            value: car.licensePlate,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CarInfoCard(
                            icon: 'assets/icons/icoclender.png',
                            label: 'RELEASE YEAR',
                            value: car.year,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CarInfoCard(
                      icon: 'assets/icons/icorangepower.png',
                      label: 'BRAND',
                      value: car.brand,
                    ),
                    SizedBox(height: 40.h),
                    CustomButton(
                      onTap: () async {
                        final updatedCar = await Get.to(
                              () => EditCarScreen(oldCar: car),
                        );

                        if (updatedCar != null) {
                          carController.selectCar(updatedCar);
                        }
                      },
                      width: double.infinity,
                      height: 68.h,
                      textcolor: Colors.white,
                      text: 'EDIT VEHICLE DETAILS',
                      gradient: AppColor.primaryGradient,
                      fontsize: 14.sp,
                      fontwight: FontWeight.bold,
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                          () => CustomButton(
                        onTap: () {
                          deleteCar(car.id);
                        },
                        width: double.infinity,
                        height: 52.h,
                        textcolor: Colors.red,
                        text: isDeleting.value
                            ? 'DELETING...'
                            : 'DELETE VEHICLE',
                        color: Colors.white,
                        fontwight: FontWeight.bold,
                        fontsize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _priceCard({
    required String daily,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: _priceItem(
        title: 'RENTAL PRICE',
        value: '\$$daily',
        suffix: '/ day',
      ),
    );
  }

  Widget _priceItem({
    required String title,
    required String value,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 12.sp,
            letterSpacing: 1.5,
            color: Colors.white70,
            fontWeight: FontWeight.w100,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              suffix,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String carStatusText(CarStatus status) {
    switch (status) {
      case CarStatus.available:
        return 'Available';
      case CarStatus.rented:
        return 'Rented';
      case CarStatus.maintenance:
        return 'Maintenance';
    }
  }

  Color statusColor(CarStatus status) {
    switch (status) {
      case CarStatus.available:
        return const Color(0xff16A34A);
      case CarStatus.rented:
        return const Color(0xffC98900);
      case CarStatus.maintenance:
        return const Color(0xffDC2626);
    }
  }
}