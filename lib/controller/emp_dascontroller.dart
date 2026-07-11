import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:four_wheels/services/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/models/machanic_bookingmodel.dart';
import 'package:four_wheels/services/services_api.dart';
import 'package:four_wheels/services/driver_api.dart';
import 'package:four_wheels/models/service_requestordermodel.dart';
import 'package:four_wheels/controller/emp_control.dart';
import 'package:four_wheels/services/admin_notifiService.dart';
import 'package:four_wheels/services/Booking_service.dart';

class EmployeeDashboardController extends GetxController {
  final selectedTabIndex = 0.obs;
  final isLoading = false.obs;

  final employeeName = ''.obs;
  final employeeImage = ''.obs;

  final driverTasks = <DriverBookingTaskModel>[].obs;
  final mechanicTasks = <MechanicMaintenanceTaskModel>[].obs;

  final tabs = [
    'Current',
    'In Progress',
    'Completed',
  ];

  final isProfileLoading = false.obs;

  final employeeEmail = ''.obs;
  final employeePhone = ''.obs;
  final employeeRole = ''.obs;
  final employeeId = ''.obs;
  final employeeStatus = ''.obs;
  final employeeRating = ''.obs;

  final licenseNumber = ''.obs;
  final licenseImage = ''.obs;
  final licenseExpiry = ''.obs;


  final isChangingPassword = false.obs;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    loadDriverInfoFromEmployees();
    loadDriverTasks();
    loadMechanicTasks();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  String get selectedStatus {
    if (selectedTabIndex.value == 0) {
      return 'Current';
    } else if (selectedTabIndex.value == 1) {
      return 'In Progress';
    } else {
      return 'Completed';
    }
  }

  void loadDriverInfoFromEmployees() {
    final employeeController = Get.find<EmployeeController>();

    final driver = employeeController.employees.firstWhereOrNull(
          (employee) => employee.role.toLowerCase() == 'driver',
    );

    if (driver == null) return;

    employeeName.value = driver.name;
    employeeImage.value = driver.imageUrl;
  }

  Future<void> loadDriverTasks() async {
    isLoading.value = true;

    try {
      final result = await DriverApi.getDriverJobs();

      if (result['success'] == true) {
        _extractEmployeeInfo(result['data']);

        final list = _extractList(result['data']);

        final tasks = list.map((item) {
          return DriverBookingTaskModel.fromJson(item);
        }).toList();

        driverTasks.assignAll(tasks);

        if (employeeName.value.isEmpty && tasks.isNotEmpty) {
          employeeName.value = tasks.first.driverName;
        }

        if (employeeImage.value.isEmpty && tasks.isNotEmpty) {
          employeeImage.value = tasks.first.driverImage;
        }

        print('DRIVER API TASKS COUNT: ${driverTasks.length}');
      } else {
        driverTasks.clear();

        print('DRIVER TASKS NOT LOADED: ${result['message']}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _extractEmployeeInfo(dynamic data) {
    if (data is Map<String, dynamic>) {
      final employee = data['employee'] ?? data['driver'] ?? data['profile'];

      if (employee is Map<String, dynamic>) {
        employeeName.value = employee['name']?.toString() ??
            employee['full_name']?.toString() ??
            employeeName.value;

        employeeImage.value = employee['image']?.toString() ??
            employee['image_url']?.toString() ??
            employee['profile_image']?.toString() ??
            employeeImage.value;
      }
    }
  }
  Future<void> loadEmployeeProfile() async {
    if (isProfileLoading.value) return;

    isProfileLoading.value = true;

    try {
      final endpoints = [
        'https://reload-hug-monastery.ngrok-free.dev/api/v1/driver/profile',
        'https://reload-hug-monastery.ngrok-free.dev/api/v1/mechanic/profile',
        'https://reload-hug-monastery.ngrok-free.dev/api/v1/employee/profile',
        'https://reload-hug-monastery.ngrok-free.dev/api/v1/profile',
        'https://reload-hug-monastery.ngrok-free.dev/api/v1/me',
      ];

      for (final endpoint in endpoints) {
        final response = await http.get(
          Uri.parse(endpoint),
          headers: {
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
            if (AuthService.token != null)
              'Authorization': 'Bearer ${AuthService.token}',
          },
        );

        print('EMP PROFILE URL: $endpoint');
        print('EMP PROFILE STATUS: ${response.statusCode}');
        print('EMP PROFILE BODY: ${response.body}');

        if (response.statusCode != 200) {
          continue;
        }

        final data = _decode(response.body);
        final profile = _extractProfile(data);

        if (profile.isEmpty) {
          continue;
        }

        employeeName.value =
            profile['name']?.toString() ??
                profile['full_name']?.toString() ??
                profile['employee_name']?.toString() ??
                '';

        employeeImage.value =
            profile['image']?.toString() ??
                profile['image_url']?.toString() ??
                profile['profile_image']?.toString() ??
                '';

        employeeEmail.value =
            profile['email']?.toString() ??
                profile['email_address']?.toString() ??
                '';

        employeePhone.value =
            profile['phone']?.toString() ??
                profile['phone_number']?.toString() ??
                '';

        employeeRole.value =
            profile['role']?.toString() ??
                profile['type']?.toString() ??
                profile['employee_type']?.toString() ??
                '';

        employeeId.value =
            profile['employee_id']?.toString() ??
                profile['employee_code']?.toString() ??
                profile['id']?.toString() ??
                '';

        employeeStatus.value =
            profile['status']?.toString() ??
                profile['availability_status']?.toString() ??
                '';

        employeeRating.value =
            profile['evaluation']?.toString() ??      // الحقل الصحيح
                profile['rating']?.toString() ??
                profile['average_rating']?.toString() ??
                profile['rate']?.toString() ??
                profile['avg_rating']?.toString() ??
                profile['mechanic_rating'] ?.toString() ??
                profile['customer_rating'] ?.toString() ??
                profile['user_rating'] ?.toString() ??
                '0';

        licenseNumber.value =
            profile['license_number']?.toString() ??
                profile['driving_license_number']?.toString() ??
                '';

        licenseImage.value =
            profile['license_image']?.toString() ??
                profile['driving_license']?.toString() ??
                profile['driving_license_image']?.toString() ??
                '';

        licenseExpiry.value =
            profile['license_expiry']?.toString() ??
                profile['license_expires_at']?.toString() ??
                profile['expiry_date']?.toString() ??
                '';

        print('EMP NAME: ${employeeName.value}');
        print('EMP IMAGE: ${employeeImage.value}');
        print('EMP ROLE: ${employeeRole.value}');
        print('EMP EMAIL: ${employeeEmail.value}');
        print('EMP PHONE: ${employeePhone.value}');

        break;
      }
    } catch (e) {
      print('LOAD EMPLOYEE PROFILE ERROR: $e');
    } finally {
      isProfileLoading.value = false;
    }
  }
  Future<void> changePassword() async {
    final current = currentPasswordController.text.trim();
    final password = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || password.isEmpty || confirm.isEmpty) {
      Get.snackbar(
        'Missing Data',
        'Please fill all password fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirm) {
      Get.snackbar(
        'Password Error',
        'New password and confirmation do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isChangingPassword.value = true;

    try {
      final result = await BookingService.changeEmployeePassword(
        currentPassword: current,
        password: password,
        passwordConfirmation: confirm,
      );

      if (result['success'] == true) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.snackbar(
          'Success',
          result['message'] ?? 'Password updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to update password.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isChangingPassword.value = false;
    }
  }

  List<DriverBookingTaskModel> get filteredDriverTasks {
    if (selectedTabIndex.value == 0) {
      return driverTasks.where((task) {
        final status = task.status.toLowerCase();

        return status == 'current' || status == 'pending';
      }).toList();
    }

    if (selectedTabIndex.value == 1) {
      return driverTasks.where((task) {
        return task.status.toLowerCase() == 'in progress';
      }).toList();
    }

    return driverTasks.where((task) {
      return task.status.toLowerCase() == 'completed';
    }).toList();
  }

  List<MechanicMaintenanceTaskModel> get filteredMechanicTasks {
    return mechanicTasks.where((task) {
      return task.status.toLowerCase() == selectedStatus.toLowerCase();
    }).toList();
  }

  Future<void> startDriverTask(String taskId) async {
    final result = await DriverApi.startDriverJob(
      jobId: int.parse(taskId),
    );

    if (result['success'] != true) {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Start task failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = driverTasks.indexWhere(
          (task) => task.id == taskId,
    );

    if (index != -1) {
      final task = driverTasks[index];

      driverTasks[index] = task.copyWith(
        status: 'In Progress',
      );

      driverTasks.refresh();
    }

    await loadDriverTasks();
  }

  Future<void> completeDriverTask(String taskId) async {
    final result = await DriverApi.completeDriverJob(
      jobId: int.parse(taskId),
    );

    if (result['success'] != true) {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Complete task failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = driverTasks.indexWhere(
          (task) => task.id == taskId,
    );

    if (index != -1) {
      final task = driverTasks[index];

      driverTasks[index] = task.copyWith(
        status: 'Completed',
        completedAt: DateTime.now(),
      );

      driverTasks.refresh();
    }

    await loadDriverTasks();
  }

  Future<bool> saveDriverTripRating({
    required String taskId,
    required int rating,
  }) async {
    if (rating < 1 || rating > 5) {
      return false;
    }

    final result = await DriverApi.submitDriverRating(
      jobId: int.parse(taskId),
      rating: rating,
    );

    if (result['success'] != true) {
      return false;
    }

    final index = driverTasks.indexWhere(
          (task) => task.id == taskId,
    );

    if (index != -1) {
      final task = driverTasks[index];

      driverTasks[index] = task.copyWith(
        tripRating: rating,
      );

      driverTasks.refresh();
    }

    return true;
  }

  Future<void> loadMechanicTasks() async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.getMechanicJobs();

      if (result['success'] == true) {
        final list = _extractList(result['data']);

        final tasks = list.map((item) {
          final service = ServiceRequestModel.fromJson(item);
          return _mapServiceToMechanicTask(service);
        }).toList();

        mechanicTasks.assignAll(tasks);

        print('MECHANIC API TASKS COUNT: ${mechanicTasks.length}');
      } else {
        print('MECHANIC TASKS NOT LOADED: ${result['message']}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  List _extractList(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return data['data'];
      }

      if (data['jobs'] is List) {
        return data['jobs'];
      }

      if (data['orders'] is List) {
        return data['orders'];
      }

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['data'] is List) {
          return inner['data'];
        }

        if (inner['jobs'] is List) {
          return inner['jobs'];
        }

        if (inner['orders'] is List) {
          return inner['orders'];
        }
      }
    }

    if (data is List) {
      return data;
    }

    return [];
  }

  MechanicMaintenanceTaskModel _mapServiceToMechanicTask(
      ServiceRequestModel service,
      ) {
    return MechanicMaintenanceTaskModel(
      id: service.id,
      customerName: service.customerName,
      customerPhone: service.customerPhone,
      carName: service.vehicleModel.isEmpty
          ? service.serviceName
          : service.vehicleModel,
      carImage: 'assets/images/carPremium.png',
      plateNumber: '-',
      reportedIssue: service.reportedIssue,
      requestDate: '${service.date} ${service.time}',
      status: _uiMechanicStatus(service.status),
      vin: '-',
      customerImage: 'assets/images/adminProfile.png',
      memberSince: '',
    );
  }

  String _uiMechanicStatus(String status) {
    final s = status.toLowerCase();

    if (s == 'active') return 'Current';

    if (s == 'inprogress' ||
        s == 'in_progress' ||
        s == 'in progress') {
      return 'In Progress';
    }

    if (s == 'completed') return 'Completed';

    return status;
  }
  Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {};
    } catch (_) {
      return {};
    }
  }

  Map<String, dynamic> _extractProfile(Map<String, dynamic> data) {
    final raw = data['data'];

    if (raw is Map<String, dynamic>) {
      if (raw['employee'] is Map<String, dynamic>) {
        return raw['employee'];
      }

      if (raw['driver'] is Map<String, dynamic>) {
        return raw['driver'];
      }

      if (raw['mechanic'] is Map<String, dynamic>) {
        return raw['mechanic'];
      }

      if (raw['user'] is Map<String, dynamic>) {
        return raw['user'];
      }

      return raw;
    }

    if (data['employee'] is Map<String, dynamic>) {
      return data['employee'];
    }

    if (data['driver'] is Map<String, dynamic>) {
      return data['driver'];
    }

    if (data['mechanic'] is Map<String, dynamic>) {
      return data['mechanic'];
    }

    if (data['user'] is Map<String, dynamic>) {
      return data['user'];
    }

    return {};
  }

  bool get isDriverProfile {
    final role = employeeRole.value.toLowerCase();

    return role.contains('driver') ||
        licenseNumber.value.trim().isNotEmpty ||
        licenseImage.value.trim().isNotEmpty;
  }

  Future<void> startMechanicTask(String taskId) async {
    final result = await ServiceApi.startRepair(
      jobId: int.parse(taskId),
    );

    if (result['success'] != true) {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Start repair failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = mechanicTasks.indexWhere(
          (task) => task.id == taskId,
    );

    if (index != -1) {
      final task = mechanicTasks[index];

      mechanicTasks[index] = task.copyWith(
        status: 'In Progress',
      );

      mechanicTasks.refresh();
    }

    await loadMechanicTasks();
  }

  Future<void> completeMechanicTask(String taskId) async {
    final result = await ServiceApi.completeJob(
      jobId: int.parse(taskId),
    );

    if (result['success'] != true) {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Complete task failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = mechanicTasks.indexWhere(
          (task) => task.id == taskId,
    );

    if (index != -1) {
      final task = mechanicTasks[index];

      mechanicTasks[index] = task.copyWith(
        status: 'Completed',
      );

      mechanicTasks.refresh();
    }

    await loadMechanicTasks();
  }

  String _extractRatingValue(Map<String, dynamic> profile) {
    final possibleValues = [
      profile['rating'],
      profile['average_rating'],
      profile['avg_rating'],
      profile['rate'],
      profile['mechanic_rating'],
      profile['mechanic_average_rating'],
      profile['average_mechanic_rating'],
      profile['customer_rating'],
      profile['ratings_avg_rating'],
    ];

    for (final value in possibleValues) {
      if (value == null) continue;

      if (value is Map<String, dynamic>) {
        final nestedValue =
            value['rating'] ??
                value['average_rating'] ??
                value['avg_rating'];

        if (nestedValue != null) {
          final parsed = double.tryParse(nestedValue.toString());
          if (parsed != null) return parsed.toStringAsFixed(1);
        }
      } else {
        final parsed = double.tryParse(value.toString());
        if (parsed != null) return parsed.toStringAsFixed(1);
      }
    }

    return '0.0';
  }
}