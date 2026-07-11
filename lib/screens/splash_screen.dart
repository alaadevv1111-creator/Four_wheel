import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/screens/register_step1.dart';
import 'dart:async';
import 'package:four_wheels/widgets/curved_continer.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        MaterialPageRoute(builder: (_) => RegisterStep1()),
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

          /// طبقة السيارة (تحت)
          Positioned(
            top: 370.h,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/car2.png",
              width: 1.sw,
              fit: BoxFit.contain,
            ),
          ),

          /// طبقة النص (فوق السيارة)
          Positioned(
            top: 160.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 140.w,
                  height: 140.w,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 4.h),

                Text(
                  "FOUR WHEELS",
                  style: GoogleFonts.poppins(
                    color: AppColor.white2,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  "L U X U R Y   I N   M O T I O N",
                  style: GoogleFonts.manrope(
                    color: AppColor.textGrey,
                    fontSize: 22.sp,
                    letterSpacing: 3,
                  ),
                ),
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
              height: 320.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Four Wheels",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.primary,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      "Join an exclusive circle of premium car enthusiasts. Your journey to effortless mobility starts here.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 13.5.sp,
                        height: 1.5,
                        color: AppColor.iconColor,
                      ),
                    ),

                    SizedBox(height: 22.h),

                    CustomButton(
                      textcolor: Colors.white,
                      text: "Lets Start",
                      width: 260.w,
                      height: 56.h,
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