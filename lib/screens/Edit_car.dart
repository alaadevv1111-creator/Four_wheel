import 'package:flutter/material.dart';
import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/car_controller.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:four_wheels/controller/uplod_controller.dart';
import 'package:four_wheels/models/car_model.dart';
import 'package:four_wheels/services/carService.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/custom_textfield.dart';
import 'package:four_wheels/widgets/emp_avater.dart';
import 'package:four_wheels/screens/Cars_screen.dart';

class EditCarScreen extends StatefulWidget {
  final CarModel oldCar;
  const EditCarScreen({super.key, required this.oldCar});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final CarController carController =
  Get.isRegistered<CarController>()
      ? Get.find<CarController>()
      : Get.put(CarController(), permanent: true);

  final DashbordController dashboardController =
  Get.isRegistered<DashbordController>()
      ? Get.find<DashbordController>()
      : Get.put(DashbordController());

  final UploadController imageController = UploadController();

  final modelController = TextEditingController();
  final plateController = TextEditingController();
  final dailyPriceController = TextEditingController();

  final selectedBrand = 'Tesla'.obs;
  final selectedYear = '2024'.obs;
  final selectedStatus = CarStatus.available.obs;
  final isLoading = false.obs;

  final List<String> brands = [
    'Tesla',
    'BMW',
    'Audi',
    'Mercedes',
    'Porsche',
    'Lucid',
  ].obs;
  final years = ['2024', '2023', '2022', '2021', '2020'];

  final statuses = [
    CarStatus.available,
    CarStatus.rented,
    CarStatus.maintenance,
  ];

  late CarModel oldCar;

  @override
  void initState() {
    super.initState();

    oldCar = widget.oldCar;

    selectedBrand.value = oldCar.brand;
    modelController.text = oldCar.model;
    selectedYear.value = oldCar.year;
    dailyPriceController.text = oldCar.dailyPrice;
    plateController.text = oldCar.licensePlate;
  }

  @override
  void dispose() {
    modelController.dispose();
    plateController.dispose();
    dailyPriceController.dispose();
    super.dispose();
  }

  void setBrandForEdit(String brand) {
    final value = brand.trim();

    if (value.isEmpty) {
      selectedBrand.value = brands.isNotEmpty ? brands.first : '';
      return;
    }

    if (!brands.contains(value)) {
      brands.add(value);
    }

    selectedBrand.value = value;
  }

  Future<void> saveChanges() async {
    final oldCar = carController.selectedCar.value;

    if (oldCar == null) return;
    if (isLoading.value) return;

    if (modelController.text.trim().isEmpty ||
        plateController.text.trim().isEmpty ||
        dailyPriceController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Data',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final updatedCar = oldCar.copyWith(
        model: modelController.text.trim(),
        brand: selectedBrand.value,
        year: selectedYear.value,
        licensePlate: plateController.text.trim(),
        dailyPrice: dailyPriceController.text.trim(),
        status: selectedStatus.value,
        imageUrl: imageController.filePath,
      );

      final result = await CarService.updateCar(
        car: updatedCar,
        imagePath: imageController.filePath,
      );

      if (result['success'] == true) {
        final updatedCar = oldCar.copyWith(
          brand: selectedBrand.value,
          model: modelController.text.trim(),
          year: selectedYear.value,
          dailyPrice: dailyPriceController.text.trim(),
          status: selectedStatus.value,
          licensePlate: plateController.text.trim(),
          imageUrl: imageController.imagePath.value.isNotEmpty
              ? imageController.imagePath.value
              : oldCar.imageUrl,
        );

        carController.updateCar(updatedCar);
        carController.selectCar(updatedCar);

        Get.back(result: updatedCar);

        Get.snackbar(
          'Success',
          result['message'] ?? 'Car updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
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
          'Edit Car',
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
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 120.h),
          child: Column(
            children: [
              Obx(
                    () => Stack(
                  children: [
                    EmployeeAvatar(
                      imagePath: imageController.imagePath.value,
                      width: double.infinity,
                      height: 260,
                      borderRadius: 8,
                    ),
                    Positioned(
                      right: 16.w,
                      bottom: 16.h,
                      child: GestureDetector(
                        onTap: imageController.pickImage,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColor.primaryGradient,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'CHANGE PHOTO',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 34.h),
              _fieldCard(
                label: 'DAILY RENTAL PRICE',
                child: Row(
                  children: [
                    Text(
                      '\$',
                      style: GoogleFonts.manrope(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff111827),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: TextField(
                        controller: dailyPriceController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.manrope(
                          fontSize: 36.sp,
                          color: const Color(0xff111827),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '250.00',
                        ),
                      ),
                    ),
                    Text(
                      '/day',
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        color: const Color(0xff45464D),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              _fieldCard(
                label: 'CAR MODEL',
                child: CustomTextField(
                  hint: 'Model S Plaid',
                  controller: modelController,
                ),
              ),
              SizedBox(height: 16.h),
              _fieldCard(
                label: 'BRAND',
                child: _brandDropdown(),
              ),
              SizedBox(height: 16.h),
              _fieldCard(
                label: 'YEAR',
                child: _yearDropdown(),
              ),
              SizedBox(height: 16.h),
              _fieldCard(
                label: 'LICENSE PLATE',
                child: CustomTextField(
                  hint: 'ABC-1234',
                  controller: plateController,
                ),
              ),
              SizedBox(height: 16.h),
              _statusPicker(),
              SizedBox(height: 34.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () => Get.back(),
                      width: double.infinity,
                      height: 56.h,
                      textcolor: const Color(0xff111827),
                      text: 'CANCEL',
                      color: const Color(0xffE5E7EB),
                      fontsize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Obx(
                          () => CustomButton(
                        onTap: () {
                          if (isLoading.value) return;
                          saveChanges();
                        },
                        width: double.infinity,
                        height: 56.h,
                        textcolor: Colors.white,
                        text: isLoading.value ? 'SAVING...' : 'SAVE CHANGES',
                        gradient: AppColor.primaryGradient,
                        fontsize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: dashboardController.currentIndex.value,
          onTap: dashboardController.changeIndex,
        ),
      ),
    );
  }

  Widget _fieldCard({
    required String label,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 10.sp,
        letterSpacing: 1.3,
        fontWeight: FontWeight.normal,
        color: const Color(0xff566276),
      ),
    );
  }

  Widget _brandDropdown() {
    return Obx(() {
      final items = brands
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      final selected = selectedBrand.value.trim();

      if (selected.isNotEmpty && !items.contains(selected)) {
        items.add(selected);
      }

      return DropdownButtonFormField<String>(
        value: selected.isEmpty ? null : selected,
        isExpanded: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: items.map((brand) {
          return DropdownMenuItem<String>(
            value: brand,
            child: Text(
              brand,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedBrand.value = value ?? '';
        },
      );
    });
  }

  Widget _yearDropdown() {
    return Obx(() {
      final items = years
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      final selected = selectedYear.value.trim();

      if (selected.isNotEmpty && !items.contains(selected)) {
        items.add(selected);
      }

      return DropdownButtonFormField<String>(
        value: selected.isEmpty ? null : selected,
        isExpanded: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: items.map((year) {
          return DropdownMenuItem<String>(
            value: year,
            child: Text(
              year,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedYear.value = value ?? '';
        },
      );
    });
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

  Widget _statusPicker() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('CAR STATUS'),
          SizedBox(height: 14.h),
          Obx(
                () => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: statuses.map((status) {
                final selected = selectedStatus.value == status;

                return GestureDetector(
                  onTap: () => selectedStatus.value = status,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : const Color(0xffE5E7EB),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      carStatusText(status),
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: selected
                            ? Colors.white
                            : const Color(0xff45464D),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}