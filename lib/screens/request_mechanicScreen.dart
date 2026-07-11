import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/request_mechaniccontroller.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/widgets/request_infocard.dart';
import 'package:four_wheels/widgets/inputfield_user.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';

class RequestMechanicScreen extends StatelessWidget {
  const RequestMechanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestMechanicController controller =
    Get.put(RequestMechanicController());

    final UserDashboardController userController =
    Get.isRegistered<UserDashboardController>()
        ? Get.find<UserDashboardController>()
        : Get.put(UserDashboardController());

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            size: 25.sp,
            color: const Color(0xff101828),
          ),
        ),
        titleSpacing: 8.w,
        title: Text(
          'Request Mechanic',
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff101828),
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RequestInfoCard(),

              SizedBox(height: 36.h),

              UserInputField(
                title: 'FULL NAME',
                hint: 'Enter your full name',
                controller: controller.fullNameController,
                validator: controller.validateRequired,
              ),

              SizedBox(height: 24.h),

              UserInputField(
                title: 'PHONE NUMBER',
                hint: '+20 000-0000',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                validator: controller.validatePhone,
              ),

              SizedBox(height: 24.h),

              UserInputField(
                title: 'CURRENT LOCATION',
                hint: 'Search your address',
                icon: Icons.location_on_outlined,
                controller: controller.locationController,
                validator: controller.validateRequired,
              ),

              SizedBox(height: 24.h),

              Obx(
                    () => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PREFERRED DATE',
                            style: GoogleFonts.manrope(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                              color: const Color(0xff45464D),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () => controller.pickDate(context),
                            child: Container(
                              height: 70.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.035),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 24.sp,
                                    color: const Color(0xff52617A),
                                  ),
                                  SizedBox(width: 18.w),
                                  Flexible(
                                    child: Text(
                                      controller.dateText,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.manrope(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff191C1E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 24.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PREFERRED TIME',
                            style: GoogleFonts.manrope(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                              color: const Color(0xff45464D),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () => controller.pickTime(context),
                            child: Container(
                              height: 70.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.035),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    size: 25.sp,
                                    color: const Color(0xff52617A),
                                  ),
                                  SizedBox(width: 18.w),
                                  Flexible(
                                    child: Text(
                                      controller.timeText,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.manrope(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff191C1E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              UserInputField(
                title: 'SERVICE DESCRIPTION',
                hint: 'Describe the issue or service you need.',
                controller: controller.descriptionController,
                validator: controller.validateRequired,
                maxLines: 5,
              ),

              SizedBox(height: 44.h),

              Obx(
                    () => CustomButton(
                  text: controller.isLoading.value
                      ? 'Submitting...'
                      : 'Submit Request',
                  textcolor: Colors.white,
                  height: 70.h,
                  gradient: AppColor.primaryGradient,
                  icon: controller.isLoading.value
                      ? null
                      : Icons.arrow_forward,
                  fontwight: FontWeight.w900,
                  fontsize: 20.sp,
                  onTap: () {
                    if (controller.isLoading.value) return;

                    controller.submitRequest();
                  },
                ),
              ),

              SizedBox(height: 28.h),

              Center(
                child: Text(
                  'SECURED BY FOUR WHEELS PRECISION™',
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff8A8F98),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => UserBottomNavBar(
          currentIndex: userController.currentIndex.value,
          onTap: userController.changeIndex,
        ),
      ),
    );
  }
}