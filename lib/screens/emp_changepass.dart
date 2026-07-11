import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/empcahangepassword_controller.dart';
import 'package:four_wheels/widgets/custom_textfield.dart';

class EmployeeChangePasswordScreen extends StatelessWidget {
  const EmployeeChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeChangePasswordController controller =
    Get.put(EmployeeChangePasswordController());

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF1F3F6),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28.sp,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Change Password',
          style: GoogleFonts.manrope(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff243044),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 38.h, 24.w, 40.h),
        child: Form(
          key: controller.formKey,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 30.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update your password',
                  style: GoogleFonts.manrope(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff191C1E),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Enter your old password, then choose a new one.',
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff64748B),
                  ),
                ),

                SizedBox(height: 32.h),

                _fieldTitle('OLD PASSWORD'),

                SizedBox(height: 10.h),

                CustomTextField(
                  hint: 'Enter old password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: controller.oldPasswordController,
                  validator: controller.validateOldPassword,
                ),

                SizedBox(height: 24.h),

                _fieldTitle('NEW PASSWORD'),

                SizedBox(height: 10.h),

                CustomTextField(
                  hint: 'Enter new password',
                  icon: Icons.lock_reset_outlined,
                  isPassword: true,
                  controller: controller.newPasswordController,
                  validator: controller.validateNewPassword,
                ),

                SizedBox(height: 24.h),

                _fieldTitle('CONFIRM PASSWORD'),

                SizedBox(height: 10.h),

                CustomTextField(
                  hint: 'Confirm new password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: controller.confirmPasswordController,
                  validator: controller.validateConfirmPassword,
                ),

                SizedBox(height: 34.h),

                Obx(
                      () => GestureDetector(
                    onTap: controller.isLoading.value
                        ? null
                        : controller.changePassword,
                    child: Container(
                      height: 64.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: controller.isLoading.value
                            ? const Color(0xffCBD5E1)
                            : const Color(0xff111827),
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      child: Center(
                        child: controller.isLoading.value
                            ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          'Change Password',
                          style: GoogleFonts.manrope(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 15.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: const Color(0xff45464D),
      ),
    );
  }
}