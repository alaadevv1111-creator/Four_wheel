import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/emp_dascontroller.dart';
import 'package:four_wheels/utils/image_uelper.dart';
import 'package:four_wheels/screens/empProf_screen.dart';
import 'package:four_wheels/widgets/emp_notfibell.dart';

import 'package:four_wheels/controller/mechanic_jobcontroller.dart';
import 'package:four_wheels/models/mechanic_jobmodel.dart';
import 'package:four_wheels/screens/mechanic_orderdetiles.dart';
import 'package:four_wheels/widgets/custom_emptab.dart';
import 'package:four_wheels/controller/driver_taskcontroller.dart';

class MechanicDashboardScreen extends StatefulWidget {
  const MechanicDashboardScreen({super.key});

  @override
  State<MechanicDashboardScreen> createState() =>
      _MechanicDashboardScreenState();
}

class _MechanicDashboardScreenState extends State<MechanicDashboardScreen> {
  late final EmployeeDashboardController profileController;

  final MechanicJobsController jobsController =
  Get.isRegistered<MechanicJobsController>()
      ? Get.find<MechanicJobsController>()
      : Get.put(MechanicJobsController(), permanent: true);

  final tabs = [
    'Current',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();

    profileController = Get.isRegistered<EmployeeDashboardController>()
        ? Get.find<EmployeeDashboardController>()
        : Get.put(EmployeeDashboardController());

    profileController.loadEmployeeProfile();
    jobsController.loadJobs();
  }

  @override
  Widget build(BuildContext context) {
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
          EmployeeNotificationBell(role: 'mechanic'),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: jobsController.loadJobs,
        child: Obx(() {
          final name = profileController.employeeName.value.trim().isEmpty
              ? 'Mechanic'
              : profileController.employeeName.value.trim();

          return ListView(
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
                'Manage your assigned service requests.',
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),

              SizedBox(height: 28.h),
              _tabs(),

              SizedBox(height: 28.h),

              if (jobsController.isLoading.value)
                Padding(
                  padding: EdgeInsets.only(top: 80.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (jobsController.filteredJobs.isEmpty)
                _emptyTasks()
              else
                ...jobsController.filteredJobs.map(
                      (job) => Padding(
                    padding: EdgeInsets.only(bottom: 18.h),
                    child: _mechanicJobCard(job),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _tabs() {
    return Obx(
          () => Row(
        children: List.generate(
          tabs.length,
              (index) {
            final selected = jobsController.selectedTabIndex.value == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  jobsController.changeTab(index);
                },
                child: Container(
                  height: 37.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xff101828)
                        : const Color(0xffF1F3F5),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: GoogleFonts.manrope(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: selected
                            ? Colors.white
                            : const Color(0xff64748B),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _mechanicJobCard(MechanicJobModel job) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MechanicJobDetailsScreen(job: job));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46.w,
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F5F9),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.build_outlined,
                    color: const Color(0xff334155),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.displayStatus.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 10.5.sp,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff94A3B8),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        job.serviceType,
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff101828),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        job.vehicleModel,
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                _statusPillSmall(job),
              ],
            ),

            SizedBox(height: 16.h),

            Text(
              'Reported Issue',
              style: GoogleFonts.manrope(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff334155),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                job.problemDescription.isEmpty
                    ? 'No issue description provided.'
                    : job.problemDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff64748B),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            _infoRow(
              icon: Icons.person_outline,
              text: 'Customer: ${job.customerName}',
            ),
            SizedBox(height: 8.h),
            _infoRow(
              icon: Icons.call_outlined,
              text: job.customerPhone.isEmpty
                  ? 'Phone: -'
                  : 'Phone: ${job.customerPhone}',
            ),
            SizedBox(height: 8.h),
            _infoRow(
              icon: Icons.calendar_month_outlined,
              text: 'Request Date: ${job.date} • ${job.time}',
            ),
            if (job.location.trim().isNotEmpty) ...[
              SizedBox(height: 8.h),
              _infoRow(
                icon: Icons.location_on_outlined,
                text: job.location,
              ),
            ],

            SizedBox(height: 18.h),
            const Divider(height: 1, color: Color(0xffE5E7EB)),
            SizedBox(height: 14.h),

            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 16.sp,
                  color: const Color(0xff94A3B8),
                ),
                SizedBox(width: 6.w),
                Text(
                  'ASSIGNED BY ADMIN',
                  style: GoogleFonts.manrope(
                    fontSize: 10.sp,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff94A3B8),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff101828),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'View Order',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: const Color(0xff94A3B8)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff475467),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusPillSmall(MechanicJobModel job) {
    Color bg;
    Color fg;
    String text;

    if (job.isCompleted) {
      bg = const Color(0xffECFDF3);
      fg = const Color(0xff12B76A);
      text = 'DONE';
    } else if (job.isInProgress) {
      bg = const Color(0xffEEF4FF);
      fg = const Color(0xff3B5BDB);
      text = 'IN PROGRESS';
    } else {
      bg = const Color(0xffFFFBEB);
      fg = const Color(0xffB45309);
      text = 'ACTIVE';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w900,
          color: fg,
        ),
      ),
    );
  }

  Widget _emptyTasks() {
    String message;

    if (jobsController.selectedTabIndex.value == 0) {
      message = 'No pending service requests';
    } else if (jobsController.selectedTabIndex.value == 1) {
      message = 'No service requests in progress';
    } else {
      message = 'No completed service requests';
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
            Icons.handyman_outlined,
            size: 50.sp,
            color: const Color(0xff94A3B8),
          ),
          SizedBox(height: 14.h),
          Text(
            message,
            textAlign: TextAlign.center,
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
}