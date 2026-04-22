import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/curved_continer.dart';
import 'register_step2.dart';
import 'login_screen.dart';
import '../widgets/SocialButton.dart';
import 'package:four_wheels/services/AuthService.dart';
import '../services/google_auth.dart';
import 'package:four_wheels/models/GoogleAuth_model.dart';
import 'dash_bord.dart';

class RegisterStep1 extends StatefulWidget {
  RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}
class _RegisterStep1State extends State<RegisterStep1>{
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.length > 12) {
      return 'Max 12 characters';
    }
    final nameRegex = RegExp(r'^[a-zA-Z]{1,12}$');

    if (!nameRegex.hasMatch(value)) {
      return 'Must start with a letter';
    }

    return null;
  }

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
  bool isLoding = false;

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
                      "STEP 1 OF 2",
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
                        Container(
                          width: 150,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColor.buttonColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 4,
                            color: AppColor.backtxt,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FULL NAME",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hint: "Shahd Alaoul",
                            controller: nameController,
                            validator: validateFullName,
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            "EMAIL",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hint: "example@gmail.com",
                            controller: emailController,
                            validator: validateEmail,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),



                          const SizedBox(height: 24),

                          Center(
                            child: CustomButton(
                              text: "Next step",
                              width: 326,
                              height: 64,
                              icon: Icons.arrow_forward,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>  RegisterStep2(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),

                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                  Center(
                    child: Text("----------------------------- or ------------------------------"),),
                    const SizedBox(height: 8,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        SocialButton(
                          icon: Icons.g_mobiledata,
                          text: "Google",
                          onTap: () async {
                            if (isLoding) return;
                            setState(() {
                              isLoding = true;
                            });
                            try {
                              final token = await GoogleAuthService.signInAndGetIdToken();
                              print("token from google:$token");

                              if (token == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Google sign-in failed')),
                                );
                                return;
                              }

                              final user = GoogleAuthModel(token: token);

                              final result = await AuthService.googleLogin(user);
                              print(result);
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'] ??
                                      "done google login")),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DashbordScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'] ??
                                      "filed google login")),
                                );
                              }
                            } catch (e) {
                              print("error=$e");
                            } finally {
                              setState(() {
                                isLoding = false;
                              });
                            }
                          }
                        ),

                      ],
                    ),

                    const SizedBox(height: 16),

                    // Login text
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You have an account? ",
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
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
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
            ),
          ),
          ),
        ],
      ),
    );
  }
}