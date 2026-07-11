import 'package:flutter/material.dart';
import 'package:four_wheels/screens/dash_bord.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/curved_continer.dart';
import '../widgets/DrivingLicense.dart';
import 'package:four_wheels/models/register_model.dart';
import 'package:four_wheels/services/AuthService.dart';
import 'package:get/get.dart';
import 'package:four_wheels/controller/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterStep2 extends StatefulWidget {
  final String name;
  final String email;

  const RegisterStep2({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.primary,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 260.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 85.h,
                    right: 0,
                    child: Image.asset(
                      "assets/images/car.png",
                      width: 497.w,
                      height: 277.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 70.h,
                    left: 35.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Four Wheels",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "L U X U R Y   I N   M O T I O N",
                          style: GoogleFonts.poppins(
                            color: AppColor.textGrey,
                            fontSize: 18.sp,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 190.h,
            left: 0,
            right: 0,
            child: CustomTopContainer(
              width: double.infinity,
              height: 804.h,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 22.h),
                  child: Form(
                    key: authController.step2FormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create account",
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.txtColor2,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          "Join the kinetic horizon of premium\ntravel.",
                          style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            color: AppColor.iconColor,
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 18.h),

                        Text(
                          "STEP 2 OF 2",
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            color: AppColor.buttonColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 4.h,
                                color: AppColor.backtxt,
                              ),
                            ),
                            Container(
                              width: 150.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: AppColor.buttonColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          "PASSWORD",
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            color: AppColor.textLight,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        CustomTextField(
                          hint: ".......",
                          width: 326.w,
                          height: 64.h,
                          isPassword: true,
                          icon: Icons.lock_outline,
                          controller: authController.passwordController,
                          validator: authController.validatePassword,
                        ),

                        SizedBox(height: 16.h),

                        Text(
                          "PASSWORD CONFIRM",
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            color: AppColor.textLight,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        CustomTextField(
                          hint: ".............",
                          width: 326.w,
                          height: 64.h,
                          isPassword: true,
                          icon: Icons.verified_user_outlined,
                          controller: authController.passwordConfirmController,
                          validator: authController.validateConfirmPassword,
                        ),

                        SizedBox(height: 16.h),

                        Text(
                          "DRIVING LICENSE",
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            color: AppColor.textLight,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),

                        // SizedBox(height: 8.h),
                        //
                        // Container(
                        //   padding: EdgeInsets.all(14.w),
                        //   decoration: BoxDecoration(
                        //     color: AppColor.backtxt,
                        //     borderRadius: BorderRadius.circular(24.r),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Do you currently hold a valid\ninternational or local driving permit?",
                        //         style: GoogleFonts.manrope(
                        //           fontSize: 14.sp,
                        //           color: AppColor.iconColor,
                        //           height: 1.5,
                        //         ),
                        //       ),
                        //       SizedBox(height: 14.h),
                        //       const Center(
                        //         child: DrivingLicense(),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(height: 24.h),

                        Center(
                          child: CustomButton(
                            textcolor: Colors.white,
                            text: "Complete Registration",
                            width: 290.w,
                            height: 58.h,
                            icon: Icons.arrow_forward,
                            onTap: () {
                              authController.register(
                                name: widget.name,
                                email: widget.email,
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 18.h),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "← RETURN TO STEP 1",
                              style: GoogleFonts.manrope(
                                color: AppColor.textHint,
                                fontSize: 14.sp,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}