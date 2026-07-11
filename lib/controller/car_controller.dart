import 'package:get/get.dart';

import 'package:four_wheels/models/car_model.dart';
import 'package:four_wheels/services/carService.dart';

class CarController extends GetxController {
  final cars = <CarModel>[].obs;
  final selectedCar = Rxn<CarModel>();

  final isLoading = false.obs;

  final totalCarsCount = 0.obs;
  final availableCarsCount = 0.obs;
  final rentedCarsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCars();
  }

  Future<void> loadCars() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final result = await CarService.getAdminCars();

      if (result['success'] == true) {
        final apiCars = result['cars'];

        if (apiCars is List<CarModel>) {
          cars.assignAll(apiCars);
        }

        totalCarsCount.value = int.tryParse(
          result['totalCount']?.toString() ?? '',
        ) ??
            cars.length;

        availableCarsCount.value = int.tryParse(
          result['availableCount']?.toString() ?? '',
        ) ??
            cars.where((car) {
              return CarModel.statusToApi(car.status) == 'available';
            }).length;

        rentedCarsCount.value = int.tryParse(
          result['rentedCount']?.toString() ?? '',
        ) ??
            cars.where((car) {
              return CarModel.statusToApi(car.status) == 'rented';
            }).length;

        print('CARS COUNT: ${cars.length}');
      } else {
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

  Future<void> loadCarDetails(String id) async {
    final result = await CarService.getCarDetails(id);

    if (result['success'] == true) {
      final apiCar = result['car'];

      if (apiCar is CarModel) {
        selectCar(apiCar);
        updateCar(apiCar);
      }
    }
  }

  void selectCar(CarModel car) {
    selectedCar.value = car;
  }

  void addCar(CarModel car) {
    final index = cars.indexWhere((item) => item.id == car.id);

    if (index == -1) {
      cars.add(car);
    } else {
      cars[index] = car;
    }

    selectedCar.value = car;
    cars.refresh();
    _refreshCountsFromLocal();
  }

  void updateCar(CarModel updatedCar) {
    final index = cars.indexWhere((car) => car.id == updatedCar.id);

    if (index != -1) {
      cars[index] = updatedCar;
    } else {
      cars.add(updatedCar);
    }

    selectedCar.value = updatedCar;
    cars.refresh();
    _refreshCountsFromLocal();
  }

  void deleteCar(String id) {
    cars.removeWhere((car) => car.id == id);

    if (selectedCar.value?.id == id) {
      selectedCar.value = null;
    }

    cars.refresh();
    _refreshCountsFromLocal();
  }

  void _refreshCountsFromLocal() {
    totalCarsCount.value = cars.length;

    availableCarsCount.value = cars.where((car) {
      return CarModel.statusToApi(car.status) == 'available';
    }).length;

    rentedCarsCount.value = cars.where((car) {
      return CarModel.statusToApi(car.status) == 'rented';
    }).length;
  }
}