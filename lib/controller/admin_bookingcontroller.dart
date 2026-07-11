import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:get/get.dart';

import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/services/Booking_service.dart';
import 'package:four_wheels/models/car_model.dart';
import 'package:four_wheels/services/carService.dart';
import 'package:four_wheels/controller/car_controller.dart';

class AdminBookingController extends GetxController {
  final pendingBookings = <DriverBookingTaskModel>[].obs;
  final activeBookings = <DriverBookingTaskModel>[].obs;
  final completedBookings = <DriverBookingTaskModel>[].obs;

  final selectedTabIndex = 0.obs;
  final isLoading = false.obs;

  final tabs = [
    'Pending',
    'In Progress',
    'Completed',
  ];

  @override
  void onInit() {
    super.onInit();
    loadPendingBookings();
  }

  List<DriverBookingTaskModel> get currentBookings {
    if (selectedTabIndex.value == 0) return pendingBookings;
    if (selectedTabIndex.value == 1) return activeBookings;
    return completedBookings;
  }

  Future<void> changeTab(int index) async {
    selectedTabIndex.value = index;

    if (index == 0) {
      await loadPendingBookings();
    } else if (index == 1) {
      await loadActiveBookings();
    } else {
      await loadCompletedBookings();
    }
  }

  Future<void> loadPendingBookings() async {
    await loadBookings(status: 'pending');
  }

  Future<void> loadActiveBookings() async {
    await loadBookings(status: 'active');
  }

  Future<void> loadCompletedBookings() async {
    await loadBookings(status: 'completed');
  }

  Future<void> loadBookings({required String status}) async {
    isLoading.value = true;

    try {
      final result = await BookingService.getAdminBookings(status: status);

      if (result['success'] == true) {
        final bookings = result['bookings'];

        if (bookings is List<DriverBookingTaskModel>) {
          if (status == 'pending') {
            pendingBookings.assignAll(bookings);
          } else if (status == 'active') {
            activeBookings.assignAll(bookings);
          } else if (status == 'completed') {
            completedBookings.assignAll(bookings);
          }
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to load bookings',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // تحديث حالة السيارة تلقائياً (Available <-> Rented) بناءً على
  // معرّف السيارة (carId) الموجود بالحجز نفسه. بيدور على السيارة
  // جوا CarController.cars (المحملة مسبقاً عند الأدمن)، يبدّل حالتها
  // فقط، ويرسلها كاملة (باقي الحقول متل ما هي) عشان ما نمسح بيانات
  // السيارة الأصلية بالغلط.
  // ============================================================
  Future<void> _updateCarStatus({
    required String carId,
    required CarStatus newStatus,
  }) async {
    print('UPDATE CAR STATUS CALLED - carId: "$carId", newStatus: $newStatus');

    if (carId.isEmpty) {
      print('UPDATE CAR STATUS ABORTED: carId is empty');
      return;
    }

    if (!Get.isRegistered<CarController>()) {
      print('UPDATE CAR STATUS ABORTED: CarController not registered');
      return;
    }

    final carController = Get.find<CarController>();

    print('CARS LOADED IN CarController: ${carController.cars.map((c) => c.id).toList()}');

    final index = carController.cars.indexWhere((c) => c.id == carId);
    if (index == -1) {
      print('UPDATE CAR STATUS ABORTED: no car found with id "$carId"');
      return;
    }

    final car = carController.cars[index];

    print('FOUND CAR: ${car.id} - current status: ${car.status}');

    if (car.status == newStatus) {
      print('UPDATE CAR STATUS SKIPPED: already $newStatus');
      return; // أصلاً بنفس الحالة، ما في داعي نرسل شي
    }

    final updatedCar = car.copyWith(status: newStatus);

    final result = await CarService.updateCar(
      car: updatedCar,
      imagePath: updatedCar.imageUrl, // رابط موجود مسبقاً (http) فما رح يرفع صورة جديدة
    );

    print('UPDATE CAR STATUS API RESULT: $result');

    if (result['success'] == true) {
      carController.updateCar(updatedCar);
      print('UPDATE CAR STATUS SUCCESS - local state updated');
    }
  }

  Future<void> approveBooking(String id) async {
    isLoading.value = true;

    try {
      final result = await BookingService.updateBookingStatus(
        id: id,
        status: 'active',
      );

      if (result['success'] == true) {
        // ناخد الحجز قبل ما نشيله من القائمة عشان ناخد منه carId
        final booking = pendingBookings.firstWhereOrNull(
              (item) => item.id == id,
        );

        pendingBookings.removeWhere((item) => item.id == id);
        await loadPendingBookings();
        await loadActiveBookings();

        if (booking != null) {
          await _updateCarStatus(
            carId: booking.carId,
            newStatus: CarStatus.rented,
          );
        }

        Get.snackbar(
          'Success',
          'Booking moved to In Progress',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to approve booking',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBooking(String id) async {
    isLoading.value = true;

    try {
      final result = await BookingService.deleteBooking(id);

      if (result['success'] == true) {
        pendingBookings.removeWhere((item) => item.id == id);
        activeBookings.removeWhere((item) => item.id == id);
        completedBookings.removeWhere((item) => item.id == id);

        Get.snackbar(
          'Success',
          'Booking deleted',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to delete booking',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeBooking(String id) async {
    isLoading.value = true;

    try {
      final result = await BookingService.updateBookingStatus(
        id: id,
        status: 'completed',
      );

      if (result['success'] == true) {
        // ناخد الحجز قبل ما نشيله من القائمة عشان ناخد منه carId
        final booking = activeBookings.firstWhereOrNull(
              (item) => item.id == id,
        );

        activeBookings.removeWhere((item) => item.id == id);

        await loadActiveBookings();
        await loadCompletedBookings();

        if (booking != null) {
          await _updateCarStatus(
            carId: booking.carId,
            newStatus: CarStatus.available,
          );
        }

        Get.snackbar(
          'Success',
          'Booking completed',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to complete booking',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}