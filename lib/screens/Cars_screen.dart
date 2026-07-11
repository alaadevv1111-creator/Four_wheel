import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:four_wheels/controller/car_controller.dart';

import 'package:four_wheels/screens/Add_cars.dart';
import 'package:four_wheels/screens/car_details.dart';
import 'package:four_wheels/screens/Edit_car.dart';
import 'package:four_wheels/services/carService.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/fleet_statusCard.dart';
import 'package:four_wheels/widgets/custom_floutingbut2.dart';
import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/ProfileAvatar.dart';
import 'package:four_wheels/screens/Profile_admin_sitting.dart';
import 'package:four_wheels/screens/General_admin_sitting.dart';

class CarsScreenScreen extends StatefulWidget {
  const CarsScreenScreen({super.key});

  @override
  State<CarsScreenScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreenScreen> {
  final DashbordController controller =
  Get.isRegistered<DashbordController>()
      ? Get.find<DashbordController>()
      : Get.put(DashbordController(), permanent: true);

  final CarController carController =
  Get.isRegistered<CarController>()
      ? Get.find<CarController>()
      : Get.put(CarController(), permanent: true);

  final isDeleting = false.obs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      carController.loadCars();
    });
  }

  Future<void> deleteCarFromApi(String id) async {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateIndexByRoute();
    });

    return Scaffold(
      backgroundColor: AppColor.backchart,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.secondary,
        title: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            "Cars",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xff111827),
            ),
          ),
        ),
        actions:  [
          AdminNotificationBell(
            initialType: 'cars',
            showFilters: false,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp,),
            ),
          ),


        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await carController.loadCars();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Obx(
                      () => CustomFleetStatusCard(
                    totalFleetTitle: "TOTAL FLEET",
                    totalFleetValue:
                    "${carController.totalCarsCount.value} Cars",
                    activeNowTitle: "AVAILABLE NOW",
                    activeNowValue:
                    carController.availableCarsCount.value.toString(),
                    excellenceText:
                    "Rented Cars: ${carController.rentedCarsCount.value}",
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final cars = carController.cars;

                  if (carController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (cars.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'No cars added yet',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            color: const Color(0xff6B7280),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: cars.map((car) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: CustomCarCard(
                          title: car.model,
                          brand: car.brand,
                          year: car.year,
                          licensePlate: car.licensePlate,
                          dailyPrice: car.dailyPrice,
                          status: car.status,
                          imageUrl: car.imageUrl,
                          onTap: () async {
                            carController.selectCar(car);
                            await carController.loadCarDetails(car.id);
                            Get.to(() => const CarDetailsScreen());
                          },
                          onEdit: () {
                            carController.selectCar(car);
                            Get.to(() =>  EditCarScreen(oldCar: car,))?.then((_) {
                              carController.loadCars();
                            });
                          },
                          onDelete: () {
                            deleteCarFromApi(car.id);
                          },
                        ),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton2(
        onTab: () {
          Get.to(() => const AddCarScreen())?.then((_) {
            carController.loadCars();
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "Add car",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }
}