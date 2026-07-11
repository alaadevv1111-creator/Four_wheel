import 'package:flutter/material.dart';
import 'package:four_wheels/models/ResetPassword_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:four_wheels/widgets/curved_continer.dart';
import 'login_screen.dart';
import 'package:four_wheels/services/AuthService.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    if (!passwordRegex.hasMatch(value.trim())) {
      return 'Must contain uppercase, lowercase, number & symbol';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void saveNewPassword() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.backgroundcolor,
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
                    top: 150.h,
                    right: 0,
                    child: Image.asset(
                      "assets/images/car.png",
                      width: 513.w,
                      height: 286.h,
                      fit: BoxFit.fill,
                    ),
                  ),

                  Positioned(
                    top: 155.h,
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
                        SizedBox(height: 3.h),
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
            top: 290.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomTopContainer(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 350.h,

              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 28.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Create new password",
                        style: GoogleFonts.poppins(
                          fontSize: 27.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.txtColor2,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Create a strong password for\n${widget.email}",
                        style: GoogleFonts.manrope(
                          fontSize: 15.sp,
                          color: AppColor.iconColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "NEW PASSWORD",
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          color: AppColor.textLight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        hint: "........",
                        width: double.infinity,
                        height: 64.h,
                        isPassword: true,
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        validator: validatePassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "CONFIRM PASSWORD",
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          color: AppColor.textLight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        hint: "........",
                        width: double.infinity,
                        height: 64.h,
                        isPassword: true,
                        icon: Icons.verified_user_outlined,
                        controller: confirmPasswordController,
                        validator: validateConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 28.h),

                      Center(
                        child: CustomButton(
                          textcolor: Colors.white,
                          text: "Save Password",
                          width: 290.w,
                          height: 58.h,
                          icon: Icons.arrow_forward,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = ResetPasswordModel(
                                email: widget.email,
                                code: widget.code,
                                password: passwordController.text.trim(),
                                passwordConfirmation: confirmPasswordController.text.trim(),
                              );

                              final result = await AuthService.resetPassword(user);

                              if (result['success'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'] ?? "success reset")),
                                );

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                      (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'] ?? "filed reset")),
                                );
                              }
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 18.h),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "← BACK",
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
          )
        ],
      ),
    );
  }
}