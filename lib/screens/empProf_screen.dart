import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/emp_dascontroller.dart';
import 'package:four_wheels/utils/image_uelper.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/emp_notfibell.dart';
import 'package:four_wheels/services/AuthService.dart';
import 'package:four_wheels/screens/login_screen.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late final EmployeeDashboardController controller;

  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<EmployeeDashboardController>()
        ? Get.find<EmployeeDashboardController>()
        : Get.put(EmployeeDashboardController());

    controller.loadEmployeeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff101828),
          ),
        ),
        title: Obx(
              () => Row(
            children: [
              _circleImage(
                controller.employeeImage.value,
                size: 32,
              ),
              SizedBox(width: 12.w),
              Text(
                'Profile',
                style: GoogleFonts.manrope(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isProfileLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(30.w, 24.h, 30.w, 40.h),
          children: [
            _headerProfile(),

            SizedBox(height: 28.h),

            _contactCard(),

            SizedBox(height: 24.h),

            if (controller.isDriverProfile) ...[
              _licenseCard(),
              SizedBox(height: 24.h),
            ],

            _changePasswordCard(),

            SizedBox(height: 24.h),

            _logoutButton(),

            SizedBox(height: 28.h),

            Center(
              child: Text(
                'Version 2.4.1 (Aether-Prod)',
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffA1A1AA),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _headerProfile() {
    final name = controller.employeeName.value.trim().isEmpty
        ? 'Employee'
        : controller.employeeName.value.trim();

    final role = controller.employeeRole.value.trim().isEmpty
        ? 'Employee'
        : controller.employeeRole.value.trim();

    final id = controller.employeeId.value.trim().isEmpty
        ? '-'
        : controller.employeeId.value.trim();

    final ratingRaw = controller.employeeRating.value.trim();
    String rating = '0.0';

    if (ratingRaw.isNotEmpty) {
      final parsed = double.tryParse(ratingRaw);
      if (parsed != null && parsed > 0) {
        rating = parsed.toStringAsFixed(1);
      } else {
        rating = '0.0';
      }
    }

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            _circleImage(
              controller.employeeImage.value,
              size: 130,
              border: true,
            ),
            Positioned(
              bottom: -18.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 14.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: const Color(0xffF59E0B),
                      size: 22.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      rating,
                      style: GoogleFonts.manrope(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff101828),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 38.h),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 30.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '$role • ID: $id',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff52525B),
          ),
        ),
      ],
    );
  }

  Widget _contactCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28.w, 26.h, 28.w, 26.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('PHONE NUMBER'),
          SizedBox(height: 10.h),
          Text(
            controller.employeePhone.value.trim().isEmpty
                ? '-'
                : controller.employeePhone.value.trim(),
            style: _valueStyle(),
          ),

          SizedBox(height: 28.h),

          _label('EMAIL ADDRESS'),
          SizedBox(height: 10.h),
          Text(
            controller.employeeEmail.value.trim().isEmpty
                ? '-'
                : controller.employeeEmail.value.trim(),
            style: _valueStyle(),
          ),
        ],
      ),
    );
  }

  Widget _licenseCard() {
    final licenseNumberValue = controller.licenseNumber.value.trim().isEmpty
        ? '-'
        : controller.licenseNumber.value.trim();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xffF1F3F5),
            padding: EdgeInsets.fromLTRB(28.w, 20.h, 28.w, 20.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Driving Credentials',
                    style: GoogleFonts.manrope(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff101828),
                    ),
                  ),
                ),
                Icon(
                  Icons.verified_user_rounded,
                  color: const Color(0xffcbe1cd),
                  size: 30.sp,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(28.w, 26.h, 28.w, 26.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _licenseImage(
                    controller.licenseImage.value,
                  ),
                ),
                SizedBox(width: 22.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        licenseNumberValue,
                        style: GoogleFonts.manrope(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff101828),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F5F9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          controller.licenseExpiry.value.trim().isEmpty
                              ? 'Valid license'
                              : 'Valid until ${controller.licenseExpiry.value}',
                          style: GoogleFonts.manrope(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xff64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _changePasswordCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Password',
            style: GoogleFonts.manrope(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff101828),
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            'Update your password to keep your account secure.',
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff94A3B8),
            ),
          ),

          SizedBox(height: 22.h),

          Obx(
                () => _passwordField(
              label: 'CURRENT PASSWORD',
              controllerField: controller.currentPasswordController,
              obscure: !showCurrentPassword.value,
              onToggle: () {
                showCurrentPassword.value = !showCurrentPassword.value;
              },
            ),
          ),

          SizedBox(height: 16.h),

          Obx(
                () => _passwordField(
              label: 'NEW PASSWORD',
              controllerField: controller.newPasswordController,
              obscure: !showNewPassword.value,
              onToggle: () {
                showNewPassword.value = !showNewPassword.value;
              },
            ),
          ),

          SizedBox(height: 16.h),

          Obx(
                () => _passwordField(
              label: 'CONFIRM NEW PASSWORD',
              controllerField: controller.confirmPasswordController,
              obscure: !showConfirmPassword.value,
              onToggle: () {
                showConfirmPassword.value = !showConfirmPassword.value;
              },
            ),
          ),

          SizedBox(height: 22.h),

          Obx(
                () => CustomButton(
              text: controller.isChangingPassword.value
                  ? 'Updating...'
                  : 'Update Password',
              textcolor: Colors.white,
              height: 54.h,
              color: const Color(0xff334155),
              fontwight: FontWeight.w900,
              fontsize: 15.sp,
              onTap: () {
                if (!controller.isChangingPassword.value) {
                  controller.changePassword();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();

                  final result = await AuthService.logout();

                  Get.offAll(() => LoginScreen());

                  Get.snackbar(
                    'Logout',
                    result['message'] ?? 'Logged out successfully',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 58.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: const Color(0xffF3C4C4),
            width: 1.6,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Color(0xffC9181C),
              ),
              SizedBox(width: 10.w),
              Text(
                'Logout',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xffC9181C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controllerField,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        SizedBox(height: 8.h),
        TextField(
          controller: controllerField,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF8FAFC),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 15.h,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xff94A3B8),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: Color(0xffE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: Color(0xffE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: Color(0xff334155),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleImage(
      String imagePath, {
        required double size,
        bool border = false,
      }) {
    final path = imagePath.trim();

    Widget image;

    if (ImageHelper.isEmpty(path)) {
      image = Container(
        width: size.w,
        height: size.w,
        color: const Color(0xffE5E7EB),
        child: Icon(
          Icons.person,
          size: size.w * 0.20,
          color: const Color(0xff64748B),
        ),
      );
    } else if (ImageHelper.isLocalFile(path)) {
      image = Image.file(
        File(path),
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size.w,
          height: size.w,
          color: const Color(0xffE5E7EB),
          child: Icon(
            Icons.person,
            size: size.w * 0.20,
            color: const Color(0xff64748B),
          ),
        ),
      );
    } else {
      image = Image.network(
        ImageHelper.resolveServerUrl(path),
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size.w,
          height: size.w,
          color: const Color(0xffE5E7EB),
          child: Icon(
            Icons.person,
            size: size.w * 0.20,
            color: const Color(0xff64748B),
          ),
        ),
      );
    }

    return Container(
      width: border ? size.w + 10.w : size.w,
      height: border ? size.w + 10.w : size.w,
      padding: border ? EdgeInsets.all(5.w) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: border ? Colors.white : Colors.transparent,
        boxShadow: border
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ]
            : [],
      ),
      child: ClipOval(child: image),
    );
  }

  Widget _licenseImage(String imagePath) {
    final path = imagePath.trim();

    if (ImageHelper.isEmpty(path)) {
      return Container(
        width: 110.w,
        height: 76.h,
        color: const Color(0xffE5E7EB),
        child: Icon(
          Icons.badge_outlined,
          color: const Color(0xff94A3B8),
          size: 34.sp,
        ),
      );
    }

    if (ImageHelper.isLocalFile(path)) {
      return Image.file(
        File(path),
        width: 110.w,
        height: 76.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _licensePlaceholder(),
      );
    }

    return Image.network(
      ImageHelper.resolveServerUrl(path),
      width: 110.w,
      height: 76.h,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _licensePlaceholder(),
    );
  }

  Widget _licensePlaceholder() {
    return Container(
      width: 110.w,
      height: 76.h,
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.badge_outlined,
        color: const Color(0xff94A3B8),
        size: 34.sp,
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 14.sp,
        letterSpacing: 2,
        fontWeight: FontWeight.w900,
        color: const Color(0xff52525B),
      ),
    );
  }

  TextStyle _valueStyle() {
    return GoogleFonts.manrope(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xff101828),
    );
  }
}