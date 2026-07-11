import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/emp_dascontroller.dart';
import 'package:four_wheels/controller/driver_taskcontroller.dart';
import 'package:four_wheels/screens/driver_orderdetiles.dart';
import 'package:four_wheels/screens/empProf_screen.dart';
import 'package:four_wheels/widgets/driver_taskcard.dart';
import 'package:four_wheels/widgets/custom_emptab.dart';
import 'package:four_wheels/utils/image_uelper.dart';
import 'package:four_wheels/widgets/emp_notfibell.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeDashboardController profileController =
    Get.isRegistered<EmployeeDashboardController>()
        ? Get.find<EmployeeDashboardController>()
        : Get.put(EmployeeDashboardController());

    final DriverTasksController tasksController =
    Get.isRegistered<DriverTasksController>()
        ? Get.find<DriverTasksController>()
        : Get.put(DriverTasksController());

    profileController.loadEmployeeProfile();

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF1F3F6),
        leadingWidth: 50.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 14.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const EmployeeProfileScreen());
              },
              child: Obx(
                    () => _employeeAvatar(
                  profileController.employeeImage.value,
                  radius: 16,
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 4.w,
        title: Text(
          'Dashboard',
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff243044),
          ),
        ),
        actions: const [
          EmployeeNotificationBell(role: 'driver'),
        ],
      ),
      body: Obx(() {
        final tasks = tasksController.currentTasks;

        final name = profileController.employeeName.value.trim().isEmpty
            ? 'Driver'
            : profileController.employeeName.value.trim();

        return RefreshIndicator(
          onRefresh: tasksController.refreshCurrentTab,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
            children: [
              Text(
                'Welcome back, $name',
                style: GoogleFonts.manrope(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff191C1E),
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'Manage your assigned booking tasks.',
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),

              SizedBox(height: 28.h),

              EmployeeTaskTabs(
                selectedIndex: tasksController.selectedTabIndex.value,
                onChanged: tasksController.changeTab,
              ),

              SizedBox(height: 28.h),

              if (tasksController.isLoading.value)
                Padding(
                  padding: EdgeInsets.only(top: 80.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (tasks.isEmpty)
                _emptyTasks(tasksController.selectedTabIndex.value)
              else
                ...tasks.map(
                      (task) {
                    final tabIndex = tasksController.selectedTabIndex.value;

                    final displayStatus = tabIndex == 0
                        ? 'Pending'
                        : tabIndex == 1
                        ? 'In Progress'
                        : 'Completed';

                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: DriverBookingTaskCard(
                        customerName: task.customerName,
                        customerPhone: task.customerPhone,
                        carName: task.carName,
                        carImage: task.carImage,
                        plateNumber: task.plateNumber,
                        pickupLocation: task.pickupLocation,
                        bookingDate: task.bookingDate,
                        price: task.price,
                        status: displayStatus,
                        onTap: () {
                          Get.to(
                                () => DriverOrderDetailsScreen(
                              task: task,
                              initialTabIndex: tabIndex,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _employeeAvatar(
      String imagePath, {
        required double radius,
      }) {
    final path = imagePath.trim();
    final size = radius * 2;

    if (ImageHelper.isEmpty(path)) {
      return CircleAvatar(
        radius: radius.r,
        backgroundColor: const Color(0xffE5E7EB),
        child: Icon(
          Icons.person,
          size: radius.sp,
          color: const Color(0xff64748B),
        ),
      );
    }

    if (ImageHelper.isLocalFile(path)) {
      return ClipOval(
        child: Image.file(
          File(path),
          width: size.w,
          height: size.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return CircleAvatar(
              radius: radius.r,
              backgroundColor: const Color(0xffE5E7EB),
              child: Icon(
                Icons.person,
                size: radius.sp,
                color: const Color(0xff64748B),
              ),
            );
          },
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        ImageHelper.resolveServerUrl(path),
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return CircleAvatar(
            radius: radius.r,
            backgroundColor: const Color(0xffE5E7EB),
            child: Icon(
              Icons.person,
              size: radius.sp,
              color: const Color(0xff64748B),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyTasks(int selectedIndex) {
    String message;

    if (selectedIndex == 0) {
      message = 'No pending tasks';
    } else if (selectedIndex == 1) {
      message = 'No tasks in progress';
    } else {
      message = 'No completed tasks';
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 55.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 50.sp,
            color: const Color(0xff94A3B8),
          ),
          SizedBox(height: 14.h),
          Text(
            message,
            style: GoogleFonts.manrope(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff64748B),
            ),
          ),
        ],
      ),
    );
  }
}