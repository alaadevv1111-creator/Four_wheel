import 'package:flutter/material.dart';
import 'package:four_wheels/models/ResetPassword_model.dart';
import 'package:google_fonts/google_fonts.dart';
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
          builder: (_) => const LoginScreen(),
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
              height: 400,
              child: Stack(
                children: [

                  Positioned(
                    top: 150,
                    right: 0,
                    child: Image.asset(
                      "assets/images/car.png",
                      width: 513,
                      height: 286,
                      fit: BoxFit.fill,
                    ),
                  ),


                  Positioned(
                    top: 155,
                    left: 35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Four Wheels",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "L U X U R Y   I N   M O T I O N",
                          style: GoogleFonts.poppins(
                            color: AppColor.textGrey,
                            fontSize: 18,
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
        top: 290,
        left: 0,
        right: 0,
        bottom: 0,
        child: CustomTopContainer(
          width: double.infinity,
          height: MediaQuery.of(context).size.height-350,

          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Create new password",
                      style: GoogleFonts.poppins(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: AppColor.txtColor2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Create a strong password for\n${widget.email}",
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        color: AppColor.iconColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "NEW PASSWORD",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColor.textLight,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hint: "........",
                      width: double.infinity,
                      height: 64,
                      isPassword: true,
                      icon: Icons.lock_outline,
                      controller: passwordController,
                      validator: validatePassword,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "CONFIRM PASSWORD",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColor.textLight,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hint: "........",
                      width: double.infinity,
                      height: 64,
                      isPassword: true,
                      icon: Icons.verified_user_outlined,
                      controller: confirmPasswordController,
                      validator: validateConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 28),

                    Center(
                      child: CustomButton(
                        text: "Save Password",
                        width: 290,
                        height: 58,
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
                    SnackBar(content: Text(result['message']??"success reset")),
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
                    SnackBar(content: Text(result['message']?? "filed reset")),
                    );

                    }
                    }
                    },
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "← BACK",
                          style: GoogleFonts.manrope(
                            color: AppColor.textHint,
                            fontSize: 14,
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

      )],
        ),
      );

    }
}