import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  final hideOldPassword = true.obs;
  final hideNewPassword = true.obs;
  final hideConfirmPassword = true.obs;

  String? validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Old password is required';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required';
    }

    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }

    if (value.trim() != newPasswordController.text.trim()) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // هون بعدين بنربط API
      // oldPasswordController.text
      // newPasswordController.text
      // confirmPasswordController.text

      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Change password failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}