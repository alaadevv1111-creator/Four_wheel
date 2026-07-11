import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/Custom_Profile_Tile.dart';
import '../widgets/custom_button.dart';
import '../widgets/ProfileAvatar.dart';
import 'Profile_admin_sitting.dart';
import 'package:four_wheels/screens/login_screen.dart';
import '../services/AuthService.dart';

class GeneralController extends GetxController {
  var appName = "Four Wheels Admin".obs;
  var currency = "USD (\$)".obs;
  var isLoading = false.obs;

  void logout() {
    // مسح التوكن محلياً
    AuthService.token = null;
    Get.offAll(() =>  LoginScreen());
  }

  void confirmLogout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text("Logout",
            style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AppColor.primary)),
        content: Text("Are you sure you want to log out?",
            style: GoogleFonts.manrope(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.manrope(color: AppColor.bcolorsmalltitle)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: Text("Logout", style: GoogleFonts.manrope(color: const Color(0xFFBA1A1A), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class generalprofilescreen extends StatelessWidget {
  const generalprofilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GeneralController());
    // Ensure ProfileController is available
    Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.secondary,
        toolbarHeight: 72.h,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: Colors.black),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.manrope(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp),
            ),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandHeader(),
                SizedBox(height: 32.h),
                _buildSectionLabel("GENERAL"),
                _buildSectionBox(
                  children: [
                    CustomProfileTile(
                      leadingIcon: Icons.smartphone_outlined,
                      title: "App Name",
                      subtitle: controller.appName.value,
                      onTap: null,
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    CustomProfileTile(
                      leadingIcon: Icons.payments_outlined,
                      title: "Currency",
                      subtitle: controller.currency.value,
                      onTap: null,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                _buildSectionLabel("ACCOUNT"),
                _buildSectionBox(
                  children: [
                    CustomProfileTile(
                      leadingIcon: Icons.manage_accounts_outlined,
                      title: "Admin Profile",
                      subtitle: "Super Admin Access",
                      onTap: () => Get.to(() => const ProfileSittingScreen()),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    CustomProfileTile(
                      leadingIcon: Icons.logout_rounded,
                      title: "Logout",
                      subtitle: "End current session",
                      color: const Color(0xFFBA1A1A),
                      trailing: Icon(
                        Icons.power_settings_new_rounded,
                        color: const Color(0xFFBA1A1A).withOpacity(0.4),
                        size: 20.sp,
                      ),
                      onTap: () => controller.confirmLogout(context),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                  child: CircularProgressIndicator(color: AppColor.primary)),
            ),
        ],
      )),
    );
  }

  Widget _buildBrandHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [AppColor.cardprim, AppColor.cardprim2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Four Wheels",
            style: GoogleFonts.manrope(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            "MANAGEMENT DASHBOARD",
            style: GoogleFonts.manrope(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.5),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.bcolorsmalltitle,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 35.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionBox({required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
