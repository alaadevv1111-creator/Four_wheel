import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:four_wheels/controller/car_controller.dart';
import 'package:four_wheels/controller/uplod_controller.dart';
import 'package:four_wheels/models/car_model.dart';
import 'package:four_wheels/screens/car_details.dart';
import 'package:four_wheels/services/carService.dart';

class AddCarController extends GetxController {
  final CarController carController = Get.find<CarController>();

  final UploadController imageUploadController = UploadController();

  final carModelController = TextEditingController();
  final licensePlateController = TextEditingController();
  final dailyPriceController = TextEditingController();

  final selectedBrand = 'Tesla'.obs;
  final selectedYear = '2024'.obs;
  final selectedStatus = CarStatus.available.obs;

  final isLoading = false.obs;
  final brands = <String>[
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

  Future<void> saveCar() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final car = CarModel(
        id: "",
        model: carModelController.text.trim(),
        brand: selectedBrand.value,
        year: selectedYear.value,
        licensePlate: licensePlateController.text.trim(),
        status: selectedStatus.value,
        dailyPrice: dailyPriceController.text.trim(),
        imageUrl: imageUploadController.filePath,
      );

      final result = await CarService.addCar(
        car: car,
        imagePath: imageUploadController.filePath,
      );

      if (result['success'] == true) {
        carController.addCar(car);
        carController.selectCar(car);

        Get.to(() => const CarDetailsScreen());
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

  @override
  void onClose() {
    carModelController.dispose();
    licensePlateController.dispose();
    dailyPriceController.dispose();
    super.onClose();
  }
}