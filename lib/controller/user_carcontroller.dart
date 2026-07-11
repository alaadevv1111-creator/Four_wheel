import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/models/user_cardetilesModel.dart';
import 'package:four_wheels/services/Booking_service.dart';
import 'package:four_wheels/screens/user_cardetilesbooking.dart';

class UserCarController extends GetxController {
  final cars = <CarDetailsModel>[].obs;

  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;
  final favoriteCarIds = <String>{}.obs;

  final tabs = [
    'All',
    'Favorite',
  ];

  String _readCarType(CarDetailsModel car) {
    try {
      final value = (car as dynamic).type;
      if (value != null) return value.toString();
    } catch (_) {}

    try {
      final value = (car as dynamic).category;
      if (value != null) return value.toString();
    } catch (_) {}

    return '';
  }

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadCars();
  }

  String get apiStartDate {
    final d = startDate.value;
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get apiEndDate {
    final d = endDate.value;
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get displayStartDate {
    return apiStartDate.isEmpty ? 'Start Date' : apiStartDate;
  }

  String get displayEndDate {
    return apiEndDate.isEmpty ? 'End Date' : apiEndDate;
  }

  bool get hasSelectedDates {
    return apiStartDate.isNotEmpty && apiEndDate.isNotEmpty;
  }

  List<CarDetailsModel> get filteredCars {
    return cars;
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    startDate.value = picked;

    if (endDate.value != null && endDate.value!.isBefore(picked)) {
      endDate.value = null;
    }

    if (endDate.value != null) {
      await loadCars();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? startDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    endDate.value = picked;

    if (startDate.value != null) {
      await loadCars();
    }
  }

  Future<void> changeTab(int index) async {
    selectedTabIndex.value = index;
    await loadCars();
  }

  Future<void> loadCars() async {
    isLoading.value = true;

    try {
      final result = await BookingService.getUserCars(
        startDate: apiStartDate,
        endDate: apiEndDate,
        favorite: selectedTabIndex.value == 1,
      );

      if (result['success'] == true) {
        final list = result['cars'];

        if (list is List<CarDetailsModel>) {
          cars.assignAll(list);
          favoriteCarIds.clear();

          for (final car in cars) {
            final id = _readCarId(car);
            if (id.isNotEmpty && isFavoriteCar(car)) {
              favoriteCarIds.add(id);
            }
          }
        } else {
          cars.clear();
        }
      } else {
        cars.clear();

        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to load cars',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void openCarDetails(CarDetailsModel car) {
    if (!hasSelectedDates) {
      Get.snackbar(
        'Select Date',
        'Please select start date and end date first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(
          () => CarDetailsBookingScreen(
        car: car,
        selectedStartDate: apiStartDate,
        selectedEndDate: apiEndDate,
      ),
    );
  }

  Future<void> toggleFavorite(CarDetailsModel car) async {
    final carId = _readCarId(car);

    if (carId.isEmpty) {
      Get.snackbar(
        'Error',
        'Car id is missing',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final oldValue = favoriteCarIds.contains(carId);
    final newValue = !oldValue;

    if (newValue) {
      favoriteCarIds.add(carId);
    } else {
      favoriteCarIds.remove(carId);
    }

    final result = newValue
        ? await BookingService.addCarToFavorite(carId: carId)
        : await BookingService.removeCarFromFavorite(carId: carId);

    if (result['success'] != true) {
      if (oldValue) {
        favoriteCarIds.add(carId);
      } else {
        favoriteCarIds.remove(carId);
      }

      Get.snackbar(
        'Favorite Error',
        result['message'] ?? 'Failed to update favorite',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  bool isFavoriteCar(CarDetailsModel car) {
    return car.isFavorite;
  }
  String readCarIdForUi(CarDetailsModel car) {
    return _readCarId(car);
  }

  String _readCarId(CarDetailsModel car) {
    try {
      final value = (car as dynamic).id;
      if (value != null) return value.toString();
    } catch (_) {}

    return '';
  }
}