import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/models/user_cardetilesModel.dart';
import 'package:four_wheels/models/booking_review.dart';
import 'package:four_wheels/models/emp_model.dart';
import 'package:four_wheels/services/Booking_service.dart';
import 'package:four_wheels/services/employye_service.dart';
import 'package:four_wheels/screens/Review_bookingscreen.dart';
import 'package:four_wheels/widgets/emp_avater.dart';

class CarDetailsBookingController extends GetxController {
  final CarDetailsModel car;
  final String selectedStartDate;
  final String selectedEndDate;

  CarDetailsBookingController({
    required this.car,
    required this.selectedStartDate,
    required this.selectedEndDate,
  });

  // ألوان هوية التطبيق - كحلي بدل الرمادي الغامق المستخدم سابقاً
  static const Color navy = Color(0xff111827);
  static const Color navyLight = Color(0xff475467);
  static const Color gold = Color(0xffF5B93D);
  static const Color goldDark = Color(0xffE9A422);
  static const Color orange = Color(0xffF7941D);

  final currentImageIndex = 0.obs;
  final isFavorite = false.obs;
  final isDescriptionExpanded = false.obs;
  final isBooking = false.obs;

  final hasLicense = false.obs;
  final licenseNumber = ''.obs;

  final availableDrivers = <EmployeeModel>[].obs;
  final selectedDriver = Rxn<EmployeeModel>();

  final licenseImagePath = ''.obs;
  final TextEditingController licenseNumberController =
  TextEditingController();

  final showLicenseForm = false.obs;
  final isSavingLicense = false.obs;

  @override
  void onInit() {
    super.onInit();
    isFavorite.value = _safeBool(_readDynamic(car, ['isFavorite', 'is_favorite']));
  }

  int get rentalDays {
    final start = _parseDate(selectedStartDate);
    final end = _parseDate(selectedEndDate);

    if (start == null || end == null) return 1;

    final days = end.difference(start).inDays;
    return days <= 0 ? 1 : days;
  }

  int get pricePerDay {
    return int.tryParse(_readCarString(['pricePerDay', 'dailyPrice', 'price_per_day'])) ?? 0;
  }

  int get estimatedTotal {
    return rentalDays * pricePerDay;
  }

  String get licenseFileName {
    if (licenseImagePath.value.isEmpty) return 'No file selected';

    final parts = licenseImagePath.value.split(RegExp(r'[\\/]'));
    return parts.isEmpty ? licenseImagePath.value : parts.last;
  }

  void changeImageIndex(int index) {
    currentImageIndex.value = index;
  }

  Future<void> toggleFavorite() async {
    final carId = _readCarString(['id']);

    if (carId.isEmpty) {
      Get.snackbar(
        'Error',
        'Car id is missing',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final oldValue = isFavorite.value;
    isFavorite.value = !oldValue;

    final result = isFavorite.value
        ? await BookingService.addCarToFavorite(carId: carId)
        : await BookingService.removeCarFromFavorite(carId: carId);

    if (result['success'] != true) {
      isFavorite.value = oldValue;

      Get.snackbar(
        'Favorite Error',
        result['message'] ?? 'Failed to update favorite',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  Future<void> openLicenseQuestion() async {
    if (isBooking.value) return;

    final start = _toApiDate(selectedStartDate);
    final end = _toApiDate(selectedEndDate);

    if (start.isEmpty || end.isEmpty) {
      Get.snackbar(
        'Missing Date',
        'Start date and end date are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isBooking.value = true;

    try {
      final setup = await BookingService.getBookingSetup(
        startDate: start,
        endDate: end,
      );

      if (setup['success'] == true) {
        hasLicense.value = setup['has_license'] == true;
        licenseNumber.value = setup['license_number']?.toString() ?? '';

        final driversRaw = setup['drivers'];

        if (driversRaw is List) {
          final drivers = driversRaw
              .whereType<Map<String, dynamic>>()
              .map((item) => EmployeeModel.fromJson(item))
              .toList();

          availableDrivers.assignAll(drivers);
        }

        print('VALID BOOKING DRIVERS: ${availableDrivers.map((e) => e.id).toList()}');
      } else {
        hasLicense.value = false;
        licenseNumber.value = '';
        availableDrivers.clear();
      }

      if (hasLicense.value) {
        _goToReview();
      } else {
        _showBookingDecisionDialog();
      }
    } finally {
      isBooking.value = false;
    }
  }

  Future<void> loadAvailableDrivers() async {
    final result = await BookingService.getBookingSetup(
      startDate: _toApiDate(selectedStartDate),
      endDate: _toApiDate(selectedEndDate),
    );

    if (result['success'] == true) {
      hasLicense.value = result['has_license'] == true;
      licenseNumber.value = result['license_number']?.toString() ?? '';

      final driversRaw = result['drivers'];

      if (driversRaw is List) {
        final drivers = driversRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => EmployeeModel.fromJson(item))
            .toList();

        availableDrivers.assignAll(drivers);
      }

      print('VALID BOOKING DRIVERS: ${availableDrivers.map((e) => e.id).toList()}');
    } else {
      availableDrivers.clear();
    }
  }

  void selectDriver(EmployeeModel driver) {
    selectedDriver.value = driver;
    showLicenseForm.value = false;
  }

  Future<void> pickLicenseImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      licenseImagePath.value = result.files.single.path!;
      print('BOOK ALERT LICENSE IMAGE: ${licenseImagePath.value}');
    }
  }

  Future<void> saveLicenseAndGoReview() async {
    final number = licenseNumberController.text.trim();

    if (number.isEmpty) {
      Get.snackbar(
        'License Number',
        'Please enter your license number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (licenseImagePath.value.isEmpty) {
      Get.snackbar(
        'License Image',
        'Please upload your license image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSavingLicense.value = true;

    try {
      final result = await BookingService.addUserLicense(
        licenseNumber: number,
        licenseImagePath: licenseImagePath.value,
      );

      if (result['success'] == true) {
        hasLicense.value = true;
        licenseNumber.value = number;

        Get.back();
        _goToReview();
      } else {
        Get.snackbar(
          'Add License Failed',
          result['message'] ?? 'Add license failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isSavingLicense.value = false;
    }
  }

  void confirmDriverAndGoReview() {
    if (selectedDriver.value == null) {
      Get.snackbar(
        'Choose Driver',
        'Please choose a driver first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.back();
    _goToReview();
  }

  void _goToReview() {
    final start = _toApiDate(selectedStartDate);
    final end = _toApiDate(selectedEndDate);

    if (start.isEmpty || end.isEmpty) {
      Get.snackbar(
        'Missing Date',
        'Start date and end date are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final review = BookingReviewModel(
      car: car,
      pickupDate: start,
      pickupTime: '',
      returnDate: end,
      returnTime: '',
      pickupLocation: '',
      returnLocation: 'Return location',
      hasLicense: hasLicense.value,
      licensePath: licenseImagePath.value,
      licenseNumber: licenseNumber.value,
      selectedDriver: selectedDriver.value,
    );

    Get.to(
          () => ReviewBookingScreen(
        review: review,
      ),
    );
  }

  // ====================================================================
  // الديالوج المصحّح:
  // - Header بتدرج ذهبي/برتقالي (متل التصميم المطلوب)
  // - زر "Confirm Driver" (ذهبي) + زر "Add License" حقيقي (كحلي) بدل
  //   التكرار القديم لنفس زر Confirm Driver مرتين
  // - لون التحديد والأزرار الكحلي وحّدته على navy = 0xff111827
  // ====================================================================
  void _showBookingDecisionDialog() {
    showLicenseForm.value = false;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Obx(
                  () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose a professional driver, or add your driving license.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff64748B),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _driversList(),

                        if (showLicenseForm.value) ...[
                          const SizedBox(height: 18),
                          _licenseForm(),
                        ],

                        const SizedBox(height: 18),

                        _actionButtons(),

                        const SizedBox(height: 10),

                        Center(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _dialogHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [gold, orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'No Driving License Found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driversList() {
    return SizedBox(
      height: 230,
      child: availableDrivers.isEmpty
          ? const Center(
        child: Text(
          'No available drivers',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.separated(
        itemCount: availableDrivers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final driver = availableDrivers[index];
          final selected = selectedDriver.value?.id == driver.id;

          return GestureDetector(
            onTap: () => selectDriver(driver),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? navy : const Color(0xffE2E8F0),
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  EmployeeAvatar(
                    imagePath: _driverImage(driver),
                    size: 46,
                    isCircle: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff101828),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${driver.role} • ${driver.status}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: navy,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _licenseForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'License Number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: licenseNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter 14-digit license number',
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: navy),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'License Image',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickLicenseImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffD9DEE3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              licenseImagePath.value.isEmpty
                  ? 'Choose license image'
                  : licenseFileName,
              style: const TextStyle(color: Color(0xff101828)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: GestureDetector(
            onTap: isSavingLicense.value ? null : saveLicenseAndGoReview,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [gold, goldDark]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                isSavingLicense.value ? 'Saving...' : 'Save License',
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    final bool canConfirm = selectedDriver.value != null;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: canConfirm ? confirmDriverAndGoReview : null,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: canConfirm
                      ? const [gold, goldDark]
                      : [Colors.grey.shade300, Colors.grey.shade300],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Confirm Driver',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: canConfirm ? navy : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => showLicenseForm.value = !showLicenseForm.value,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [navy, navyLight]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Add License',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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

  DateTime? _parseDate(String value) {
    final text = value.trim();

    if (text.isEmpty) return null;

    final direct = DateTime.tryParse(text);
    if (direct != null) return direct;

    return null;
  }

  String _toApiDate(String value) {
    final date = _parseDate(value);

    if (date == null) return value.trim();

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String _driverImage(EmployeeModel driver) {
    try {
      final value = driver.imageUrl;
      if (value.toString().isNotEmpty) return value.toString();
    } catch (_) {}

    try {
      final dynamic value = (driver as dynamic).image;
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    } catch (_) {}

    return '';
  }

  dynamic _readDynamic(dynamic object, List<String> keys) {
    for (final key in keys) {
      try {
        switch (key) {
          case 'isFavorite':
            return object.isFavorite;
          case 'is_favorite':
            return object.is_favorite;
        }
      } catch (_) {}
    }

    return null;
  }

  String _readCarString(List<String> keys) {
    for (final key in keys) {
      try {
        dynamic value;

        switch (key) {
          case 'id':
            value = (car as dynamic).id;
            break;
          case 'pricePerDay':
            value = (car as dynamic).pricePerDay;
            break;
          case 'dailyPrice':
            value = (car as dynamic).dailyPrice;
            break;
          case 'price_per_day':
            value = (car as dynamic).pricePerDay;
            break;
        }

        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      } catch (_) {}
    }

    return '';
  }

  bool _safeBool(dynamic value) {
    if (value == true) return true;
    if (value.toString() == '1') return true;
    if (value.toString().toLowerCase() == 'true') return true;
    return false;
  }

  @override
  void onClose() {
    licenseNumberController.dispose();
    super.onClose();
  }
}