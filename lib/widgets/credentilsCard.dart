import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CredentialsCard extends StatelessWidget {
  final String title;
  final String expDate;
  final String credentialId;
  final String iconPath;
  final VoidCallback? onTap;

  const CredentialsCard({
    super.key,
    required this.title,
    required this.expDate,
    required this.credentialId,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(22.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE8F8F0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: const Color(0xff35C28A),
                      size: 20.sp,
                    ),
                  ),
                ),

                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    "Credentials",
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1E1E2D),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF4FF),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "LICENSE VERIFIED",
                    style: GoogleFonts.manrope(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff3B82F6),
                      letterSpacing: .5,
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 26.h),

            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(22.r),
              child: Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF7F8FA),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Row(
                  children: [
                    Image.asset(iconPath, width: 20.w),
                    SizedBox(width: 18.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff27364A),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Exp: $expDate · ID: $credentialId",
                            style: GoogleFonts.manrope(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}