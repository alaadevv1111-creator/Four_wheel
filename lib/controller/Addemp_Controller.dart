import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/models/emp_model.dart';
import 'package:four_wheels/controller/emp_control.dart';
import 'package:four_wheels/screens/employy_details.dart';
import 'package:four_wheels/services/employye_service.dart';
import 'package:four_wheels/screens/employy_details.dart';


class AddEmployeeController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final EmployeeController empController = Get.find<EmployeeController>();

  final selectedRole = 'Driver'.obs;
  final isLoading = false.obs;

  final RxBool isActive = true.obs;

  final nameError = RxnString();
  final phoneError = RxnString();

  final emailError = RxnString();

  final roles = [
    'Driver',
    'Mechanic',
  ];

  void changeStatus(bool value) {
    isActive.value = value;
  }

  void changeRole(String? value) {
    if (value == null) return;
    selectedRole.value = value;
  }

  void validateName(String value) {
    if (value.trim().isEmpty) {
      nameError.value = 'Full name is required';
    } else {
      nameError.value = null;
    }
  }

  void validatePhone(String value) {
    if (value.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
    } else {
      phoneError.value = null;
    }
  }

  void validateEmail(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email';
    } else {
      emailError.value = null;
    }
  }

  bool validateForm() {

    validateName(fullNameController.text);
    validatePhone(phoneController.text);
    validateEmail(emailController.text);

    return nameError.value == null && phoneError.value == null && emailError.value == null;

  }

  Future<void> saveEmployee({
    required String drivingLicensePath,
  }) async {
    print('SAVE EMPLOYEE START');
    print('NAME: ${fullNameController.text}');
    print('PHONE: ${phoneController.text}');
    print('EMAIL: ${emailController.text}');
    print('ROLE: ${selectedRole.value}');
    print('LICENSE PATH IN SAVE: $drivingLicensePath');

    if (!validateForm()) {
      print('VALIDATION FAILED');
      print('NAME ERROR: ${nameError.value}');
      print('PHONE ERROR: ${phoneError.value}');
      print('EMAIL ERROR: ${emailError.value}');
      return;
    }


    final role = selectedRole.value.trim().toLowerCase();

    if (role == 'driver' && drivingLicensePath.isEmpty) {
      Get.snackbar(
        'Error',
        'Please upload driving license',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    print('VALIDATION PASSED - BEFORE API');
    isLoading.value = true;

    try {
      isLoading.value = true;

      final name = fullNameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final role = selectedRole.value.trim().toLowerCase();
      final status = isActive.value ? 'active' : 'inactive';

      if (role == 'driver' && drivingLicensePath
          .trim()
          .isEmpty) {
        Get.snackbar(
          'Missing License',
          'Driver must upload driving license',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final result = await EmployeeService.addEmployee(
        name: name,
        phone: phone,
        email: email,
        role: role,
        status: status,
        hireDate: '2026-05-25',
        drivingLicensePath: role == 'driver' ? drivingLicensePath.trim() : '',
      );

      if (result['success'] == true) {
        await empController.loadEmployees();

        final addedEmployee = empController.employees.firstWhereOrNull(
              (emp) => emp.email.trim().toLowerCase() == email.toLowerCase(),
        );

        if (addedEmployee != null) {
          empController.selectEmployee(addedEmployee);

          Get.off(() => const EmployyDetailsScreen());
        } else {
          Get.back();
        }
        Get.snackbar(
          'Success',
          result['message'] ?? 'Employee added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to add employee',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}