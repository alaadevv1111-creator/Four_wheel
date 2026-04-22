import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:four_wheels/widgets/curved_continer.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:four_wheels/services/AuthService.dart';
import 'package:four_wheels/models/ForgetPassword_model.dart';
import 'VerficationCode.dart';
import 'package:four_wheels/models/CheckEmail_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,

      body: Stack(
        children: [

          /// 🔵 الخلفية
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.backgroundcolor,
          ),

          /// 🔝 اللوجو (اختياري)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', height: 120,width: 200,),
                const SizedBox(height: 5),
                Text(
                  "FOUR WHEELS",
                  style: GoogleFonts.manrope(
                    color: AppColor.white2,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          /// ⚪ الكونتينر الجاهز
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomTopContainer(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,

              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// العنوان
                      Text(
                        "Forgot Password",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Enter your email to receive reset code",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: AppColor.iconColor,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Email Field
                      CustomTextField(
                        hint: "example@email.com",
                        controller: emailController,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 30),

                      /// Button
                      Center(
                        child: CustomButton(
                          text: "Send Code",
                          width: 220,
                          height: 60,
                          icon: Icons.arrow_forward,

                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                final emailData = CheckEmailModel(
                                  email: emailController.text.trim(),
                                );

                                final checkResult = await AuthService.checkEmail(emailData);

                                if (checkResult['success'] == true) {
                                  final forgotData = ForgotPasswordModel(
                                    email: emailController.text.trim(),
                                  );

                                  final forgotResult = await AuthService.forgotPassword(forgotData);

                                  if (forgotResult['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(forgotResult['message']?? "success forgot")),
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VerificationCodeScreen(
                                          email: emailController.text.trim(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(forgotResult['message']?? "filed forgot")),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(checkResult['message']?? "filed check")),
                                  );
                                }
                              }
                            },

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
//    final result = await AuthService.forgotPassword(
//                                 emailController.text.trim(),
//                               );
//
//                               if (result['success']) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => VerificationCodeScreen(
//                                       email: emailController.text.trim(),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(result['message'])),
//                                 );
//                               }