import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/screens/register_step1.dart';
import 'dart:async';
import 'package:four_wheels/widgets/curved_continer.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  RegisterStep1()),
      );
    });
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
              top: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
              Transform.translate(
              offset: Offset(0, 60),
                 child:  Image.asset('assets/images/logo.png'),

              ),
                 Text(
                    "FOUR WHEELS",
                    style: GoogleFonts.poppins(
                      color: AppColor.white2,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height: 3),

                  Text(
                    "L U X U R Y   I N   M O T I O N",
                    style: GoogleFonts.manrope(
                      color: AppColor.textGrey,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 47),

                  Image.asset("assets/images/car2.png"),
                ],
              ),
            ),

            /// الجزء السفلي (الكيرف + البوتون)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: CustomTopContainer(
                width: double.infinity,
                height: 354,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        "Welcome to Four Wheels",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColor.primary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Join an exclusive circle of premium car\nenthusiasts. Your journey to effortless\nmobility starts here.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 17,
                          color: AppColor.iconColor,
                        ),
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        text: "Lets Start",
                        width: 281.67,
                        height: 68,
                        icon: Icons.arrow_forward,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterStep1(),
                            ),
                          );
                        },
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


