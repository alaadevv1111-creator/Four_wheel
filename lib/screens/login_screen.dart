import 'package:flutter/material.dart';
import 'package:four_wheels/screens/dash_bord.dart';
import 'package:four_wheels/screens/register_step1.dart';
import 'package:google_fonts/google_fonts.dart';

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
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must length > 8';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain:\nUppercase, lowercase, number & symbol';
    }

    return null;
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
            color: AppColor.primary,
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
                    top: 110,
                    right: 0,
                    child: Image.asset(
                      "assets/images/car.png",
                      width: 513,
                      height: 286,
                      fit: BoxFit.fill,
                    ),
                  ),

                  Positioned(
                    top: 80,
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
                        const SizedBox(height: 13),
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
            top: 230,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomTopContainer(
              width: double.infinity,
              height: 700,
              child:SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColor.txtColor2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please enter your details to access your fleet.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColor.iconColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email Address",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColor.textLight,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          CustomTextField(
                            hint: "example@gmail.com",
                            width: 326,
                            height: 64,
                            icon: Icons.email_outlined,
                            controller: emailController,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "PASSWORD",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColor.textLight,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          CustomTextField(
                            hint: ".............",
                            width: 326,
                            height: 64,
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: passwordController,
                            validator: validatePassword,
                            keyboardType: TextInputType.visiblePassword,
                          ),

                          const SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Center(
                            child: CustomButton(
                              text: "Login",
                              width: 326,
                              height: 64,
                              icon: Icons.arrow_forward,
                              onTap: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final user = LoginModel(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  final result = await AuthService.login(user);

                                  if (result['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['message'] ?? 'success'),
                                      ),
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DashbordScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['message'] ?? 'failed'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 8),

                          Center(
                            child: Text("----------------------------- or ------------------------------"),),
                          const SizedBox(height: 4,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialButton(
                                icon: Icons.g_mobiledata,
                                text: "Google",
                                onTap: () async {
                                  final token =
                                  await GoogleAuthService.signInAndGetIdToken();

                                  if (token == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Google sign-in failed'),
                                      ),
                                    );
                                    return;
                                  }

                                  final user = GoogleAuthModel(token: token);

                                  final result = await AuthService.googleLogin(user);

                                  if (result['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['message'] ?? 'success'),
                                      ),
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DashbordScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['message'] ?? 'failed'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Dont have an account ? ",
                                  style: GoogleFonts.poppins(
                                    color: AppColor.textHint,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterStep1(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "SignUp",
                                    style: GoogleFonts.poppins(
                                      color: AppColor.primary,
                                      fontSize: 14,
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

