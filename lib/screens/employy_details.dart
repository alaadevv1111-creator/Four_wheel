import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/emp_control.dart';
import 'package:four_wheels/models/emp_model.dart';
import 'package:four_wheels/screens/Editemp_screen.dart';
import 'package:four_wheels/widgets/content_info.dart';
import 'package:four_wheels/widgets/credentilsCard.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/widgets/emp_avater.dart';
import 'package:four_wheels/utils/image_uelper.dart';

class EmployyDetailsScreen extends StatefulWidget {
  const EmployyDetailsScreen({super.key});

  @override
  State<EmployyDetailsScreen> createState() => _EmployyDetailsScreenState();
}

class _EmployyDetailsScreenState extends State<EmployyDetailsScreen> {
  bool loadedDetails = false;

  static const Color bgColor = Color(0xffF7F8FC);
  static const Color darkColor = Color(0xff111827);
  static const Color greyText = Color(0xff667085);
  static const Color lightGrey = Color(0xffF2F4F7);
  static const Color green = Color(0xff12B76A);
  static const Color red = Color(0xffF04438);

  @override
  Widget build(BuildContext context) {
    final EmployeeController empController = Get.find<EmployeeController>();

    return Obx(() {
      final EmployeeModel? employee = empController.selectedEmployee.value;
      if (employee != null && !loadedDetails) {
        loadedDetails = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          empController.loadEmployeeDetails(employee.id);
        });
      }

      if (employee == null) {
        return const Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Text('No employee selected'),
          ),
        );
      }

      final String role = employee.role.trim().toLowerCase();
      final bool isDriver = role == 'driver' || role.contains('driver');

      final String licensePath = employee.drivingLicensePath.trim();
      final bool showLicenseCard = isDriver;

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 18.sp,
            ),
          ),
          title: Text(
            'Employee Details',
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 120.h),
            child: Column(
              children: [
                _employeeHeader(employee),

                SizedBox(height: 24.h),

                ContactInformationCard(
                  phoneNumber: employee.phone,
                  workEmail: employee.email,
                ),

                SizedBox(height: 18.h),

                if (showLicenseCard) ...[
                  CredentialsCard(
                    iconPath: 'assets/icons/icoclender.png',
                    title: 'Driving License',
                    expDate: "Dec 2025",
                    credentialId: "#${employee.id}",
                    onTap: () {
                      final path = employee.drivingLicensePath.trim();

                      print('LICENSE CLICKED');
                      print('LICENSE PATH: $path');

                      if (!employee.hasLicense) {
                        Get.snackbar(
                          'No License',
                          'This driver has no license',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      if (ImageHelper.isEmpty(path)) {
                        Get.snackbar(
                          'License Exists',
                          'License is saved, but the image path is not returned from backend',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      _showDrivingLicense(path);
                    },
                  ),

                  SizedBox(height: 28.h),
                ] else ...[
                  SizedBox(height: 28.h),
                ],

                CustomButton(
                  text: 'Edit Employee',
                  gradient: AppColor.primaryGradient,
                  textcolor: Colors.white,
                  onTap: () async {
                    empController.selectEmployee(employee);
                    await Get.to(() => EditEmployeeScreen());

                    await empController.loadEmployees();

                    final freshEmployee = empController.employees.firstWhereOrNull(
                          (emp) =>
                      emp.id == employee.id ||
                          emp.email.trim().toLowerCase() ==
                              employee.email.trim().toLowerCase(),
                    );

                    if (freshEmployee != null) {
                      empController.selectEmployee(freshEmployee);
                    }

                    await empController.loadEmployeeDetails(
                      freshEmployee?.id ?? employee.id,
                    );
                  },
                ),

                SizedBox(height: 22.h),

                GestureDetector(
                  onTap: () {
                    _confirmDelete(empController, employee);
                  },
                  child: Text(
                    'Delete Employee',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xffF04438),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _smallAdminImage() {
    return CircleAvatar(
      radius: 16.r,
      backgroundImage: const AssetImage('assets/images/adminProfile.png'),
    );
  }

  Widget _employeeHeader(EmployeeModel employee) {
    final bool isActive = employee.status.trim().toLowerCase() == 'active';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _employeeImage(employee.imageUrl, size: 92),
            Positioned(
              right: 4.w,
              bottom: 8.h,
              child: Container(
                width: 17.w,
                height: 17.h,
                decoration: BoxDecoration(
                  color: green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.w,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        Text(
          employee.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 6.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xffEEF4FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                employee.role.trim().isEmpty
                    ? 'EMPLOYEE'
                    : employee.role.trim().toUpperCase(),
                style: GoogleFonts.manrope(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff667085),
                ),
              ),
            ),

            SizedBox(width: 10.w),

            Container(
              width: 7.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: isActive ? green : red,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(width: 5.w),

            Text(
              isActive ? 'ACTIVE' : 'INACTIVE',
              style: GoogleFonts.manrope(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w800,
                color: isActive ? green : red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmDelete(
      EmployeeController empController,
      EmployeeModel employee,
      ) {
    Get.defaultDialog(
      title: 'Delete Employee',
      middleText: 'Are you sure you want to delete this employee?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () {
        empController.deleteEmployee(employee.id);
        Get.back();
        Get.back();
      },
    );
  }

  void _showDrivingLicense(String licensePath) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 22.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xffD0D5DD),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              'Driving License',
              style: GoogleFonts.manrope(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 14.h),

            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 230.h,
                width: double.infinity,
                child: _licenseImage(licensePath),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _employeeImage(String path, {required double size}) {
    return EmployeeAvatar(
      imagePath: path,
      size: size,
      isCircle: true,
    );
  }

  Widget _licenseImage(String path) {
    if (ImageHelper.isEmpty(path)) {
      return _imageError(Icons.badge_outlined);
    }
    return EmployeeAvatar(
      imagePath: path,
      width: double.infinity,
      height: 230,
      isCircle: false,
      borderRadius: 16,
    );
  }

  Widget _imageError(IconData icon) {
    return Container(
      color: const Color(0xffEAECF0),
      child: Center(
        child: Icon(
          icon,
          size: 36.sp,
          color: const Color(0xff98A2B3),
        ),
      ),
    );
  }
}