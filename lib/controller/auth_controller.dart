import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/models/login_model.dart';
import 'package:four_wheels/models/register_model.dart';
import 'package:four_wheels/models/GoogleAuth_model.dart';

import 'package:four_wheels/services/AuthService.dart';
import 'package:four_wheels/services/google_auth.dart';
import 'package:four_wheels/screens/mechanic_dasscreen.dart';
import 'package:four_wheels/screens/dash_bord.dart';
import 'package:four_wheels/screens/register_step2.dart';
import 'package:four_wheels/screens/driver_dasscreen.dart';
import 'package:four_wheels/screens/user_dashboard.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';

class AuthController extends GetxController {
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final isLoading = false.obs;

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.length > 12) {
      return 'Max 12 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');

    if (!nameRegex.hasMatch(value)) {
      return 'Must start with a letter';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must length > 8';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain:\nUppercase, lowercase, number & symbol';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }

    if (value != passwordController.text) {
      return "Password isnt mutch";
    }

    return null;
  }

  void goToStep2() {
    if (step1FormKey.currentState!.validate()) {
      Get.to(
            () => RegisterStep2(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
  }) async {
    if (!step2FormKey.currentState!.validate()) return;

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final user = RegisterModel(
        name: name,
        email: email,
        password: passwordController.text.trim(),
        passwordConfirmation: passwordConfirmController.text.trim(),
      );

      final result = await AuthService.register(user);

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'success',
          snackPosition: SnackPosition.BOTTOM,
        );

        print('LOGIN RESULT: $result');

        final data = result['data'];

        final role = (
            result['role'] ??
                result['user']?['role'] ??
                data?['role'] ??
                data?['user']?['role'] ??
                ''
        ).toString().trim().toLowerCase();

        print('LOGIN ROLE: $role');

        if (role == 'admin') {
          Get.offAll(() => DashbordScreen());
        } else if (role == 'mechanic') {
          Get.offAll(() => MechanicDashboardScreen());
        } else if (role == 'driver') {
          Get.offAll(() => DriverDashboardScreen());
        } else if (role == 'user') {
          Get.offAll(() => UserDashboard());
        } else {
          Get.snackbar(
            'Error',
            'Role not found: $role',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
      } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final user = LoginModel(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );

      final result = await AuthService.login(user);

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'success',
          snackPosition: SnackPosition.BOTTOM,

        );
        Get.put(UserDashboardController(), permanent: true);
        print('LOGIN RESULT: $result');

        final data = result['data'];

        final role = (
            result['role'] ??
                result['user']?['role'] ??
                data?['role'] ??
                data?['user']?['role'] ??
                ''
        ).toString().trim().toLowerCase();

        print('LOGIN ROLE: $role');

        if (role == 'admin') {
          Get.offAll(() => DashbordScreen());
        } else if (role == 'mechanic') {
          Get.offAll(() => MechanicDashboardScreen());
        } else if (role == 'driver') {
          Get.offAll(() => DriverDashboardScreen());
        }else if (role == 'user') {
          Get.offAll(() => UserDashboard());
        } else {
          Get.snackbar(
            'Error',
            'Role not found: $role',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? result['massage'] ?? 'failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleLogin() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final token = await GoogleAuthService.signInAndGetIdToken();

      print("token from google:$token");

      if (token == null) {
        Get.snackbar(
          'Error',
          'Google sign-in failed',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final user = GoogleAuthModel(token: token);

      final result = await AuthService.googleLogin(user);

      print(result);

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? "done google login",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAll(() => DashbordScreen());
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? result['massage'] ?? "filed google login",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("error=$e");

      Get.snackbar(
        'Error',
        'Google sign-in failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearPasswords() {
    passwordController.clear();
    passwordConfirmController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();

    loginEmailController.dispose();
    loginPasswordController.dispose();

    passwordController.dispose();
    passwordConfirmController.dispose();

    super.onClose();
  }
}