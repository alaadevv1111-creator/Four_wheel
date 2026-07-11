import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/profileavator.dart';
import 'ForgetPassword.dart';
import 'Profile_admin_sitting.dart';
import 'favorites_screen.dart';
import 'user_edit_profile_screen.dart';
import 'login_screen.dart';
import '../services/UserProfileService.dart';
import '../services/AuthService.dart';
import '../models/user_profile_model.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';
import 'user_bookingScreen.dart';

class UserProfileController extends GetxController {
  var fullName = "User Name".obs;
  var email = "user@example.com".obs;
  var phone = "+1 (555) 000-0000".obs;
  var profileImageUrl = RxnString();
  var licenseNumber = "".obs;
  var licenseImageUrl = RxnString();
  var localImageFile = Rxn<File>();
  var isLoading = false.obs;

  final profile = Rxn<UserProfileModel>();

  final ImagePicker _picker = ImagePicker();
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  String get initials {
    String name = fullName.value.trim();
    if (name.isEmpty) return "??";

    List<String> words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    } else {
      return name.length >= 2
          ? name.substring(0, 2).toUpperCase()
          : name[0].toUpperCase();
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final result = await UserProfileService.getProfile();

      if (result['success'] == true) {
        final profile = UserProfileModel.fromJson(result['data']);

        fullName.value = profile.name ?? fullName.value;
        email.value = profile.email ?? email.value;
        phone.value = profile.phoneNumber ?? profile.phone ?? phone.value;
        licenseNumber.value = profile.licenseNumber ?? "";
        profileImageUrl.value = _formatImageUrl(profile.image);
        licenseImageUrl.value = _formatImageUrl(profile.licenseImage);
      }
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String? _formatImageUrl(String? rawPath) {
    if (rawPath == null || rawPath.trim().isEmpty) return null;
    String cleanPath = rawPath.trim();
    String baseUrl = "https://reload-hug-monastery.ngrok-free.dev";

    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return "$cleanPath?t=${DateTime.now().millisecondsSinceEpoch}";
    }

    if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);
    if (cleanPath.startsWith('storage/')) {
      return "$baseUrl/$cleanPath?t=${DateTime.now().millisecondsSinceEpoch}";
    }
    return "$baseUrl/storage/$cleanPath?t=${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<void> updateField(String key, String val, RxString obs) async {
    if (val == obs.value) return;
    try {
      isLoading.value = true;
      Map<String, dynamic> updateData = {key: val};
      if (key == 'phone') updateData = {'phone': val, 'phone_number': val};

      final result = await UserProfileService.updateProfile(
        profile: UserProfileModel.fromJson(updateData),
      );
      if (result['success'] == true) {
        obs.value = val;
        Get.snackbar("Success", "Updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      final file = File(image.path);
      localImageFile.value = file;
      try {
        isLoading.value = true;
        final result = await UserProfileService.updateProfile(
          profile: UserProfileModel(),
          profileImage: file,
        );
        if (result['success'] == true) {
          await fetchProfile();
          localImageFile.value = null;
          Get.snackbar("Success", "Profile image updated", backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          localImageFile.value = null;
          Get.snackbar("Error", result['message'] ?? "Upload failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      } catch (e) {
        localImageFile.value = null;
        Get.snackbar("Error", "Upload failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }
  }



  Future<void> updatePassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    try {
      isLoading.value = true;
      final result = await UserProfileService.updatePassword(
        UpdatePasswordModel(
          oldPassword: currentPasswordController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
        ),
      );
      if (result['success'] == true) {
        Get.back();
        Get.snackbar("Success", "Password updated", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", result['message'] ?? "Update failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }



  void logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Get.back(); // إغلاق الدايلوج أولاً

              try {
                // 1. مسح التوكن من الذاكرة المؤقتة (Static)
                AuthService.token = null;
                AuthService.clearLocalAuth();

                // 2. مسح التوكن من كاش الموبايل نهائياً (إذا كنتِ تستخدمين SharedPreferences أو GetStorage)
                // var prefs = await SharedPreferences.getInstance();
                // await prefs.clear();

                // 3. 🛑 السطر السحري لحل مشكلتك: تدمير كاش المفضلة تماماً 🛑
                if (Get.isRegistered<FavoritesController>()) {
                  await Get.delete<FavoritesController>(force: true);
                }

                // 4. حذف بقية الـ Controllers المتعلقة بالبروفايل لإنهاء الكاش تماماً
                await Get.delete<UserProfileController>(force: true);
                await Get.delete<ProfileController>(force: true);
                if (Get.isRegistered<UserEditProfileController>()) {
                  await Get.delete<UserEditProfileController>(force: true);
                }

              } catch (e) {
                debugPrint("Error during logout clear: $e");
              }

              // 5. الانتقال لصفحة تسجيل الدخول وتطهير الـ Stack بالكامل
              Get.offAll(() =>  LoginScreen());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  double? _extractRating(dynamic profile) {
    if (profile == null) return null;
    dynamic value;
    try { value = (profile as dynamic).rating; } catch (_) {}
    try { value ??= (profile as dynamic).stars; } catch (_) {}
    try { value ??= (profile as dynamic).average_rating; } catch (_) {}
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  String _formatLicense(String license) {
    if (license.trim().isEmpty) return "0000000-0000000";
    String clean = license.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.length == 14) {
      return "LIC-${clean.substring(0, 7)}-${clean.substring(7)}";
    }
    return license;
  }

  void _showLicenseImage(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      Get.snackbar("Error", "No license image available",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200.h,
                    width: double.infinity,
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController());
    final UserDashboardController navController = Get.find<UserDashboardController>();


    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        backgroundColor: AppColor.mainBc,
        elevation: 0,
        centerTitle: false,

        title: Text(
          "My profile",
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),

      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Center(child: Profileavator(radius: 60.r, fontSize: 40.sp)),
                SizedBox(height: 16.h),
                Text(
                  "Welcome back,",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.bcolorsmalltitle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      controller.fullName.value,
                      style: GoogleFonts.manrope(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                        letterSpacing: 0.45,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

// ==== Rating Badge ====
//                 SizedBox(height: 12.h),

// ==== Rating Badge (only if rating > 0) ====
                if ((controller.profile.value?.rating ?? 0) > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: const Color(0xffF59E0B), size: 20.sp),
                        SizedBox(width: 5.w),
                        Text(
                          controller.profile.value!.rating!.toStringAsFixed(1),
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xff101828),
                          ),
                        ),
                      ],
                    ),
                  ),

                // SizedBox(height: 12.h),


                SizedBox(height: 32.h),
                Container(
                  width: 342.w,
                  height: 88.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColor.backhedar,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showLicenseImage(context, controller.licenseImageUrl.value),
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: AppColor.cardprim2,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(Icons.badge_outlined, color: Colors.white, size: 24.sp),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "DRIVER LICENSE",
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.bcolorsmalltitle,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _formatLicense(controller.licenseNumber.value),
                                style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  width: 342.w,
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColor.borderGray),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Personal Details",
                            style: GoogleFonts.manrope(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                          Icon(Icons.info_outline, color: Colors.grey[400], size: 20.sp),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildDetailItem("Full Name", controller.fullName.value),
                      _buildDetailItem("Email Address", controller.email.value),
                      _buildDetailItem("Phone Number", controller.phone.value, showDivider: false),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MANAGEMENT",
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.bcolorsmalltitle,
                          letterSpacing: 1.6,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: 342.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColor.borderGray),
                        ),
                        child: Column(
                          children: [
                            _buildManagementTile(
                              icon: Icons.grid_view_rounded,
                              title: "My Order",
                              onTap: ()=>
                                  Get.to(()=> UserBookingsScreen()),
                            ),
                            _buildDivider(),

                            _buildDivider(),
                            _buildManagementTile(
                              icon: Icons.lock_outline_rounded,
                              title: "Change Password",
                              onTap: () => _showPasswordBottomSheet(context, controller),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: "EDIT PROFILE",
                  onTap: () => Get.to(() => const UserEditProfileScreen()),
                  gradient: const [AppColor.cardprim2, AppColor.cardprim],
                  textColor: Colors.white,
                  width: 342.w,
                  height: 56.h,
                  borderRadius: 12.r,
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: "Log Out",
                  icon: Icons.logout,
                  onTap: () => controller.logout(

                  ),
                  backgroundColor: const Color(0xFFF9F0F0),
                  textColor: const Color(0xFFBA1A1A),
                  width: 342.w,
                  height: 56.h,
                  borderRadius: 12.r,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      )),
      bottomNavigationBar: Obx(
            () =>
            UserBottomNavBar(
              currentIndex: navController.currentIndex.value,
              onTap: navController.changeIndex,
            ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool showDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        if (showDivider) ...[
          SizedBox(height: 12.h),
          Divider(color: const Color(0xFFF1F5F9), thickness: 1),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColor.borderGray, thickness: 1, height: 1.h);
  }

  Widget _buildManagementTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: AppColor.cardprim, size: 22.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColor.textMuted, size: 14.sp),
          ],
        ),
      ),
    );
  }


  void _showPasswordBottomSheet(BuildContext context, UserProfileController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              CustomTextField(hint: "Current Password", isPassword: true, controller: controller.currentPasswordController),
              SizedBox(height: 12.h),
              CustomTextField(hint: "New Password", isPassword: true, controller: controller.passwordController),
              SizedBox(height: 12.h),
              CustomTextField(hint: "Confirm New Password", isPassword: true, controller: controller.confirmPasswordController),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                  child: Text(
                    "Forgot password?",
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF424242),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Obx(() => CustomButton(
                text: controller.isLoading.value ? "Updating..." : "Change Password",
                onTap:  () => controller.updatePassword(),
                width: double.infinity,
                height: 48.h,
                backgroundColor: AppColor.cardprim2,
              )),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    ).then((_) {
      controller.currentPasswordController.clear();
      controller.passwordController.clear();
      controller.confirmPasswordController.clear();
    });
  }

}

