import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:four_wheels/screens/dash_bord.dart';
import 'package:four_wheels/screens/Rentels_screen.dart';
import 'package:four_wheels/screens/Employee_mangment.dart';
import 'package:four_wheels/screens/cars_screen.dart';

import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/services/Booking_service.dart';
import 'package:four_wheels/screens/Accessories.dart';

class DashbordController extends GetxController {
  final currentIndex = 0.obs;
  final recentBookings = <DriverBookingTaskModel>[].obs;
  final isRecentBookingsLoading = false.obs;

  int getIndexFromRoute(String route) {
    if (route.contains('dashboard')) return 0;
    if (route.contains('rentals')) return 1;
    if (route.contains('employees')) return 2;
    if (route.contains('cars')) return 3;
    if (route.contains('accessories')) return 4;

    return currentIndex.value;
  }
  @override
  void onInit() {
    super.onInit();
    loadRecentBookings();
  }

  List<DriverBookingTaskModel> get lastFourRecentBookings {
    return recentBookings
        .where((booking) => booking.status.trim().toLowerCase() == 'pending')
        .take(4)
        .toList();
  }

  void updateIndexByRoute() {
    currentIndex.value = getIndexFromRoute(Get.currentRoute);
  }
  Future<void> loadRecentBookings() async {
    isRecentBookingsLoading.value = true;

    try {
      final result = await BookingService.getDashboardRecentBookings();

      if (result['success'] == true) {
        final bookings = result['bookings'];

        if (bookings is List<DriverBookingTaskModel>) {
          recentBookings.assignAll(bookings);
        } else {
          recentBookings.clear();
        }
      } else {
        recentBookings.clear();
      }
    } finally {
      isRecentBookingsLoading.value = false;
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;

    if (index == 0) {
      Get.off(
            () => DashbordScreen(),

      );
    } else if (index == 1) {
      Get.off(
            () => const RentalsScreen(),

      );
    } else if (index == 2) {
      Get.off(
            () => const EmployeeMangmentScreen(),

      );
    } else if (index == 3) {
      Get.off(
            () => const CarsScreenScreen(),

      );
    } else if (index == 4) {
      Get.off(
            () => const AccScrean(),

      );
    }
  }
}