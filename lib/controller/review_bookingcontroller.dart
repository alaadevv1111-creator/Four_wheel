import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:four_wheels/models/booking_review.dart';
import 'package:four_wheels/models/emp_model.dart';
import 'package:four_wheels/services/Booking_service.dart';
import 'package:four_wheels/services/employye_service.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/screens/user_bookingScreen.dart';

class ReviewBookingController extends GetxController {
  final BookingReviewModel review;

  ReviewBookingController({
    required this.review,
  });

  final fullInsurance = false.obs;
  final professionalDriver = false.obs;

  final availableDrivers = <EmployeeModel>[].obs;
  final selectedDriver = Rxn<EmployeeModel>();

  final hasLicense = false.obs;
  final licenseNumber = ''.obs;
  final licenseImagePath = ''.obs;

  final TextEditingController licenseNumberController =
  TextEditingController();

  final TextEditingController pickupLocationController =
  TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    hasLicense.value = review.hasLicense;
    licenseNumber.value = review.licenseNumber;
    licenseImagePath.value = review.licensePath;
    pickupLocationController.text = review.pickupLocation;

    if (review.selectedDriver != null) {
      selectedDriver.value = review.selectedDriver;
      professionalDriver.value = false;
    }

    loadAvailableDrivers();
  }

  int get rentalDays {
    final start = _parseDate(review.pickupDate);
    final end = _parseDate(review.returnDate);

    if (start == null || end == null) return 4;

    final days = end.difference(start).inDays;
    return days <= 0 ? 1 : days;
  }

  double get pricePerDay {
    return double.tryParse(review.carPricePerDay) ?? 0.0;
  }

  double get rentalTotal {
    return rentalDays * pricePerDay;
  }

  double get insuranceTotal {
    return fullInsurance.value ? 25 * rentalDays.toDouble() : 0.0;
  }

  double get driverTotal {
    return professionalDriver.value && selectedDriver.value != null
        ? 50 * rentalDays.toDouble()
        : 0.0;
  }

  double get taxesAndFees {
    return 82.40;
  }

  double get totalAmount {
    return rentalTotal + insuranceTotal + driverTotal + taxesAndFees;
  }

  String money(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  String get licenseFileName {
    if (licenseImagePath.value.isEmpty) return 'No file selected';

    final parts = licenseImagePath.value.split(RegExp(r'[\\/]'));
    return parts.isEmpty ? licenseImagePath.value : parts.last;
  }

  void toggleInsurance(bool value) {
    fullInsurance.value = value;
  }

  void toggleProfessionalDriver(bool value) {
    professionalDriver.value = value;
  }

  void selectDriver(EmployeeModel driver) {
    selectedDriver.value = driver;
  }
  Future<void> loadAvailableDrivers() async {
    final result = await BookingService.getBookingSetup(
      startDate: _toApiDate(review.pickupDate),
      endDate: _toApiDate(review.returnDate),
    );

    if (result['success'] == true) {
      final driversRaw = result['drivers'];

      if (driversRaw is List) {
        final drivers = driversRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => EmployeeModel.fromJson(item))
            .toList();

        availableDrivers.assignAll(drivers);
      }

      print('REVIEW VALID BOOKING DRIVERS: ${availableDrivers.map((e) => e.id).toList()}');
    } else {
      availableDrivers.clear();
    }
  }
  List _extractEmployeesList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      if (data['data'] is List) return data['data'];

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['data'] is List) return inner['data'];

        if (inner['data'] is Map<String, dynamic>) {
          final inner2 = inner['data'];

          if (inner2['data'] is List) return inner2['data'];
        }
      }
    }

    return [];
  }

  Future<void> pickLicenseImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      licenseImagePath.value = result.files.single.path!;
    }
  }

  Future<void> addLicense() async {
    final number = licenseNumberController.text.trim();

    if (number.isEmpty) {
      Get.snackbar(
        'Error',
        'License number is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (licenseImagePath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'License image is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await BookingService.addUserLicense(
        licenseNumber: number,
        licenseImagePath: licenseImagePath.value,
      );

      if (result['success'] == true) {
        hasLicense.value = true;
        licenseNumber.value = number;

        Get.back();

        Get.snackbar(
          'Success',
          result['message'] ?? 'License added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Add license failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmBooking() async {
    if (isLoading.value) return;

    if (pickupLocationController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Pickup location is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDriver.value != null && !professionalDriver.value) {
      Get.snackbar(
        'Professional Driver Required',
        'Please enable Professional Driver to confirm the extra driver fee.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (professionalDriver.value && selectedDriver.value == null) {
      Get.snackbar(
        'Error',
        'Please choose a driver',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDriver.value == null && !hasLicense.value) {
      Get.snackbar(
        'Error',
        'Please add your driving license or choose a driver',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await BookingService.createBooking(
        carId: review.carId,
        startDate: _toApiDate(review.pickupDate),
        endDate: _toApiDate(review.returnDate),
        totalPrice: totalAmount.toString(),
        pickupLocation: pickupLocationController.text.trim(),
        driverId: professionalDriver.value
            ? selectedDriver.value?.id ?? ''
            : '',
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'Booking created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        final UserDashboardController navController =
        Get.isRegistered<UserDashboardController>()
            ? Get.find<UserDashboardController>()
            : Get.put(UserDashboardController());

        // My Orders tab عند اليوزر
        navController.currentIndex.value = 2;

        Get.off(() => const UserBookingsScreen());

      } else {
        _showBookingBlockedAlert(
          result['message'] ?? 'You cannot create more than one booking at the same time.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  DateTime? _parseDate(String value) {
    final text = value.trim();

    if (text.isEmpty) return null;

    final direct = DateTime.tryParse(text);
    if (direct != null) return direct;

    final months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    final cleaned = text.replaceAll(',', '');
    final parts = cleaned.split(' ');

    if (parts.length >= 3 && parts[0].length >= 3) {
      final key = parts[0].toLowerCase().substring(0, 3);
      final month = months[key];
      final day = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (month != null && day != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  String _toApiDate(String value) {
    final date = _parseDate(value);

    if (date == null) return value;

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
  void _showBookingBlockedAlert(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xffFFF7E6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffF59E0B),
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Booking Not Allowed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff25364D),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
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

  @override
  void onClose() {
    licenseNumberController.dispose();
    pickupLocationController.dispose();
    super.onClose();
  }
}