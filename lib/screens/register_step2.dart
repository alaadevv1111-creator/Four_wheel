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
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must lentgh >8 ';
    }
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

  if (!passwordRegex.hasMatch(value)) {
    return 'Password must contain:\nUppercase, lowercase, number & symbol';
  }

  return null;
}

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }

    if (value != passwordController.text) {
      return "Password isnt mutch";
    }
    return null;
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
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
              height: 260,
              child: Stack(
                children: [
                  Positioned(
                    top: 85,
                    right: 0,
                    child: Image.asset(
                      "assets/images/car.png",
                      width: 497,
                      height: 277,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 70,
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
                        const SizedBox(height: 6),
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
            top: 190,
            left: 0,
            right: 0,
            child: CustomTopContainer(
              width: double.infinity,
              height: 804,
              child:SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create account",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColor.txtColor2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Join the kinetic horizon of premium\ntravel.",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: AppColor.iconColor,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "STEP 2 OF 2",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColor.buttonColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 4,
                              color: AppColor.backtxt,
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColor.buttonColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
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

                      const SizedBox(height: 8),

                      CustomTextField(
                        hint: ".......",
                        width: 326,
                        height: 64,
                        isPassword: true,
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        validator: validatePassword

                      ),

                      const SizedBox(height: 16),

                      Text(
                        "PASSWORD CONFIRM",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColor.textLight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hint: ".............",
                        width: 326,
                        height: 64,
                        isPassword: true,
                        icon: Icons.verified_user_outlined,
                        controller: passwordConfirmController,
                        validator: validateConfirmPassword,


                      ),

                      const SizedBox(height: 16),

                      Text(
                        "DRIVING LICENSE",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColor.textLight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.backtxt,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Do you currently hold a valid\ninternational or local driving permit?",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: AppColor.iconColor,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Center(
                              child: DrivingLicense(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: CustomButton(
                          text: "Complete Registration",
                          width: 290,
                          height: 58,
                          icon: Icons.arrow_forward,
                          onTap: () async{
                            if (_formKey.currentState!.validate()) {
                              final user = RegisterModel(
                                name: widget.name,
                                email: widget.email,
                                password: passwordController.text.trim(),
                                passwordConfirmation: passwordConfirmController.text.trim(),
                              );

                              final result = await AuthService.register(user);

                              if (result?['success']== true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => DashbordScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result?['message'] ?? 'somthing wrong')),
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
                            "← RETURN TO STEP 1",
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
          ),
          ),
        ],
      ),
    );
  }
}