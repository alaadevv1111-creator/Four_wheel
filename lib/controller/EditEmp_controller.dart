import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:four_wheels/controller/emp_control.dart';
import 'package:four_wheels/services/employye_service.dart';
import 'uplod_controller.dart';
import 'package:four_wheels/utils/image_uelper.dart';
class EditEmployeeController extends GetxController {
  final EmployeeController empController = Get.find<EmployeeController>();
  final UploadController uploadController = UploadController();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final selectedImagePath = ''.obs;

  final selectedRole = 'driver'.obs;
  final isActive = true.obs;
  final isLoading = false.obs;

  final nameError = RxnString();
  final phoneError = RxnString();
  final emailError = RxnString();

  final List<String> roles = [
    'driver',
    'mechanic',
  ];

  @override
  void onInit() {
    super.onInit();

    final employee = empController.selectedEmployee.value;

    if (employee != null) {
      fullNameController.text = employee.name;
      phoneController.text = employee.phone;
      emailController.text = employee.email;
      selectedRole.value = employee.role.trim().toLowerCase();
      isActive.value = employee.status.toLowerCase().trim() == 'active';

      uploadController.imagePath.value = employee.imageUrl;
      selectedImagePath.value = '';
    }
  }

  void changeRole(String? value) {
    if (value == null) return;
    selectedRole.value = value.trim().toLowerCase();
  }

  void changeStatus(bool value) {
    isActive.value = value;
  }

  void validateName(String value) {
    nameError.value = value.trim().isEmpty ? 'Full name is required' : null;
  }

  void validatePhone(String value) {
    phoneError.value = value.trim().isEmpty ? 'Phone number is required' : null;
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

    return nameError.value == null &&
        phoneError.value == null &&
        emailError.value == null;
  }

  Future<void> pickEmployeeImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;

      selectedImagePath.value = path;
      uploadController.imagePath.value = path;
    }
  }

  Future<void> saveChanges() async {
    print('SAVE CHANGES CLICKED');

    final oldEmployee = empController.selectedEmployee.value;

    if (oldEmployee == null) {
      Get.snackbar(
        'Error',
        'No employee selected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!validateForm()) {
      print('EDIT VALIDATION FAILED');
      print('NAME ERROR: ${nameError.value}');
      print('PHONE ERROR: ${phoneError.value}');
      print('EMAIL ERROR: ${emailError.value}');
      return;
    }

    final name = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final role = selectedRole.value.trim().toLowerCase();
    final status = isActive.value ? 'active' : 'inactive';


    final String licensePath = oldEmployee.drivingLicensePath.trim();


    isLoading.value = true;

    final currentImagePath = uploadController.filePath.trim();

    final bool hasNewImage = ImageHelper.isLocalFile(currentImagePath);

    final String imagePathToSend = hasNewImage ? currentImagePath : '';

    print('CURRENT IMAGE PATH: $currentImagePath');
    print('IMAGE PATH TO SEND: $imagePathToSend');

    try {
      final result = await EmployeeService.updateEmployee(
        id: oldEmployee.id,
        name: name,
        phone: phone,
        email: email,
        role: role,
        status: status,
        imagePath: uploadController.filePath,
        drivingLicensePath: role == 'driver' ? licensePath : '',

      );

      print('UPDATE RESULT: $result');

      if (result['success'] == true) {
        await empController.loadEmployees();

        final updatedEmployee = empController.employees.firstWhereOrNull(
              (emp) => emp.id == oldEmployee.id,
        );

        if (updatedEmployee != null) {
          empController.selectEmployee(updatedEmployee);
        }

        Get.back();

        Get.snackbar(
          'Success',
          result['message'] ?? 'Employee updated successfully',
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