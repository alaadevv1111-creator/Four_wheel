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
import 'package:four_wheels/screens/car_details.dart';
import 'package:four_wheels/services/carService.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/custom_textfield.dart';
import 'package:four_wheels/widgets/uplode_doc.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final CarController carController =
  Get.isRegistered<CarController>()
      ? Get.find<CarController>()
      : Get.put(CarController(), permanent: true);

  final DashbordController dashboardController =
  Get.isRegistered<DashbordController>()
      ? Get.find<DashbordController>()
      : Get.put(DashbordController());

  final UploadController carImageController = UploadController();

  final TextEditingController modelController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController dailyPriceController = TextEditingController();

  final selectedBrand = 'Tesla'.obs;
  final selectedYear = '2024'.obs;
  final selectedStatus = CarStatus.available.obs;
  final isLoading = false.obs;

  final brands = ['Tesla', 'Audi', 'Porsche', 'Mercedes', 'BMW', 'Lucid'];
  final years = ['2024', '2023', '2022', '2021', '2020'];

  final statuses = [
    CarStatus.available,
    CarStatus.rented,
    CarStatus.maintenance,
  ];

  @override
  void dispose() {
    modelController.dispose();
    plateController.dispose();
    dailyPriceController.dispose();
    super.dispose();
  }

  Future<void> saveCar() async {
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
      final car = CarModel(
        id: '',
        model: modelController.text.trim(),
        brand: selectedBrand.value,
        year: selectedYear.value,
        licensePlate: plateController.text.trim(),
        status: selectedStatus.value,
        dailyPrice: dailyPriceController.text.trim(),
        imageUrl: carImageController.filePath,
      );

      final result = await CarService.addCar(
        car: car,
        imagePath: carImageController.filePath,
      );

      if (result['success'] == true) {
        final apiCar = result['car'];

        await carController.loadCars();

        if (apiCar is CarModel) {
          carController.selectCar(apiCar);

          Get.snackbar(
            'Success',
            result['message'] ?? 'Car added successfully',
            snackPosition: SnackPosition.BOTTOM,
          );

          Get.to(() => const CarDetailsScreen());
        } else {
          Get.snackbar(
            'Success',
            result['message'] ?? 'Car added successfully',
            snackPosition: SnackPosition.BOTTOM,
          );

          Get.back();
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? result['massage'] ?? 'Add car failed',
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
          'Add Cars',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
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
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 120.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('MEDIA'),
              SizedBox(height: 12.h),
              CustomUploadCard(
                selectedFile: carImageController.selectedFile,
                isUploading: carImageController.isUploading,
                onTap: carImageController.pickImage,
                title: 'Upload Car Image',
                subtitle: 'Recommended size: 1600×900px',
                icon: Icons.add_a_photo_outlined,
                backgroundImage: 'assets/images/Addcar.png',
                backgroundImageOpacity: 0.90,
                height: 195,
              ),
              SizedBox(height: 24.h),
              _sectionTitle('VEHICLE IDENTITY'),
              SizedBox(height: 12.h),
              _buildIdentityCard(),
              SizedBox(height: 24.h),
              _sectionTitle('PRICING STRATEGY'),
              SizedBox(height: 12.h),
              _buildPricingCard(),
              SizedBox(height: 24.h),
              _sectionTitle('CONFIGURATION'),
              SizedBox(height: 12.h),
              Obx(
                    () => _dropdown(
                  value: selectedStatus.value,
                  items: statuses,
                  itemText: (item) => carStatusText(item as CarStatus),
                  onChanged: (value) {
                    if (value == null) return;
                    selectedStatus.value = value as CarStatus;
                  },
                ),
              ),
              SizedBox(height: 40.h),
              Obx(
                    () => CustomButton(
                  onTap: () {
                    if (isLoading.value) return;
                    saveCar();
                  },
                  width: double.infinity,
                  height: 60.h,
                  textcolor: Colors.white,
                  text: isLoading.value ? 'Saving...' : 'Save Car',
                  gradient: AppColor.primaryGradient,
                  fontwight: FontWeight.bold,
                  fontsize: 18.sp,
                ),
              ),
              SizedBox(height: 22.h),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff566276),
                    ),
                  ),
                ),
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

  Widget _buildIdentityCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldTitle('Car Model'),
          SizedBox(height: 10.h),
          CustomTextField(
            hint: 'e.g. Model S Plaid',
            controller: modelController,
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldTitle('Brand'),
                    SizedBox(height: 10.h),
                    Obx(
                          () => _dropdown(
                        value: selectedBrand.value,
                        items: brands,
                        onChanged: (value) {
                          if (value != null) {
                            selectedBrand.value = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldTitle('Year'),
                    SizedBox(height: 10.h),
                    Obx(
                          () => _dropdown(
                        value: selectedYear.value,
                        items: years,
                        onChanged: (value) {
                          if (value != null) {
                            selectedYear.value = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _fieldTitle('License Plate'),
          SizedBox(height: 10.h),
          CustomTextField(
            hint: 'ABC-1234',
            controller: plateController,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldTitle('Daily Rental Price'),
          SizedBox(height: 10.h),
          CustomTextField(
            hint: '299',
            controller: dailyPriceController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required dynamic value,
    required List items,
    required ValueChanged<dynamic> onChanged,
    String Function(dynamic item)? itemText,
  }) {
    return Container(
      height: 55.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: AppColor.backtxt,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(
                itemText != null ? itemText(item) : item.toString(),
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff191C1E),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.7,
        color: const Color(0xff45464D),
      ),
    );
  }

  Widget _fieldTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xff45464D),
      ),
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
          blurRadius: 24.r,
          offset: Offset(0, 12.h),
        ),
      ],
    );
  }
}