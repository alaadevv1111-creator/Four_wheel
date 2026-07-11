import 'package:flutter/material.dart';
import 'package:four_wheels/screens/dash_bord.dart';
import 'package:four_wheels/screens/register_step1.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/controller/auth_controller.dart';
import '../constants/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/curved_continer.dart';
import '../widgets/SocialButton.dart';
import 'ForgetPassword.dart';
import 'package:four_wheels/models/login_model.dart';
import 'package:four_wheels/services/AuthService.dart';
import 'package:four_wheels/models/GoogleAuth_model.dart';
import 'package:four_wheels/services/google_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController =
  Get.isRegistered<AuthController>()
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
              height: 400.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 110.h,
                    right: 0,
                    child: Image.asset(
                      "assets/images/car.png",
                      width: 513.w,
                      height: 286.h,
                      fit: BoxFit.fill,
                    ),
                  ),

                  Positioned(
                    top: 80.h,
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
                        SizedBox(height: 13.h),
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
            top: 230.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomTopContainer(
              width: double.infinity,
              height: 700.h,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 22.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.poppins(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.txtColor2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Please enter your details to access your fleet.",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: AppColor.iconColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Form(
                        key: authController.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Address",
                              style: GoogleFonts.manrope(
                                fontSize: 12.sp,
                                color: AppColor.textLight,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                            SizedBox(height: 10.h),

                            CustomTextField(
                              hint: "example@gmail.com",
                              width: 326.w,
                              height: 64.h,
                              icon: Icons.email_outlined,
                              controller: authController.loginEmailController,
                              validator: authController.validateEmail,
                              keyboardType: TextInputType.emailAddress,
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
                            SizedBox(height: 10.h),

                            CustomTextField(
                              hint: ".............",
                              width: 326.w,
                              height: 64.h,
                              icon: Icons.lock_outline,
                              isPassword: true,
                              controller: authController.loginPasswordController,
                              validator: authController.validatePassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),

                            SizedBox(height: 6.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => ForgotPasswordScreen());
                                  },
                                  child: Text(
                                    "Forgot password?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 14.h),

                            Center(
                              child: CustomButton(
                                textcolor: Colors.white,
                                text: "Login",
                                width: 326.w,
                                height: 64.h,
                                icon: Icons.arrow_forward,
                                onTap: authController.login,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Center(
                              child: Text(
                                "----------------------------- or ------------------------------",
                              ),
                            ),
                            SizedBox(height: 4.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocialButton(
                                  icon: Icons.g_mobiledata,
                                  text: "Google",
                                  onTap: authController.googleLogin,
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Dont have an account ? ",
                                    style: GoogleFonts.poppins(
                                      color: AppColor.textHint,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => RegisterStep1());
                                    },
                                    child: Text(
                                      "SignUp",
                                      style: GoogleFonts.poppins(
                                        color: AppColor.primary,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}