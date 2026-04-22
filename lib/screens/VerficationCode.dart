import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/curved_continer.dart';
import '../widgets/custom_button.dart';
import 'ResetPassword.dart';
import 'package:four_wheels/models/VerifyCode_model.dart';
import 'package:four_wheels/services/AuthService.dart';


class VerificationCodeScreen extends StatefulWidget {
  final String email;


  const VerificationCodeScreen({
    super.key,
    required this.email,

  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final code1Controller = TextEditingController();
  final code2Controller = TextEditingController();
  final code3Controller = TextEditingController();
  final code4Controller = TextEditingController();
  final code5Controller = TextEditingController();
  final code6Controller = TextEditingController();

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();


  String? errorText;

  @override
  void dispose() {
    code1Controller.dispose();
    code2Controller.dispose();
    code3Controller.dispose();
    code4Controller.dispose();
    code5Controller.dispose();
    code6Controller.dispose();

    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    focus5.dispose();
    focus6.dispose();
    super.dispose();
  }

  String get fullCode =>
      code1Controller.text +
          code2Controller.text +
          code3Controller.text +
          code4Controller.text +
          code5Controller.text +
          code6Controller.text;

  Widget otpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
  }) {
    return Container(
      width: 50,
      height: 55,
      decoration: BoxDecoration(
        color: AppColor.backtxt,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
      ),
    );
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verification Code",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColor.txtColor2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter the 6-digit code sent to\n${widget.email}",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: AppColor.iconColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        otpBox(
                          controller: code1Controller,
                          focusNode: focus1,
                          nextFocus: focus2,
                        ),
                        otpBox(
                          controller: code2Controller,
                          focusNode: focus2,
                          nextFocus: focus3,
                        ),
                        otpBox(
                          controller: code3Controller,
                          focusNode: focus3,
                          nextFocus: focus4,
                        ),
                        otpBox(
                          controller: code4Controller,
                          focusNode: focus4,
                        ),
                        otpBox(
                          controller: code5Controller,
                          focusNode: focus5,
                        ),
                        otpBox(
                          controller: code6Controller,
                          focusNode: focus6,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    if (errorText != null)
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),

                    const SizedBox(height: 28),

                    Center(
                      child: CustomButton(
                        text: "Verify",
                        width: 290,
                        height: 58,
                        icon: Icons.arrow_forward,
                        onTap: () async {
                          if (fullCode.length != 6) {
                            setState(() {
                              errorText = "Enter the 6-digit code";
                            });
                            return;
                          }

                          setState(() {
                            errorText = null;
                          });

                          final verifyData = VerifyCodeModel(
                            email: widget.email,
                            code: fullCode
                          );

                          final result = await AuthService.verifyCode(verifyData);

                          if (result['success'] == true ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result['message']?? 'success verfication')),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordScreen(
                                  email: widget.email,
                                  code: fullCode,
                                  
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result['message']?? "field verfication" )),
                            );
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

                    const Spacer(),

                    Center(
                      child: Container(
                        width: 95,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}