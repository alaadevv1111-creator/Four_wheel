import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../services/ProfileService2.dart';
import '../services/AuthService.dart';
import 'package:four_wheels/screens/login_screen.dart';
import 'General_admin_sitting.dart';
import '../widgets/Custom_Editable_Card.dart';
import '../widgets/Custom_Profile_Tile.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/ProfileAvatar.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  var fullName = "User Name".obs;
  var email = "user@example.com".obs;
  var phone = "+1 (555) 000-0000".obs;
  var companyName = "Precision Wheels Luxury Rentals".obs;
  var profileImageUrl = RxnString();
  var localImageFile = Rxn<File>();
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }
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
      final result = await ProfileService.getProfile();

      if (result['success'] == true) {
        // 1. تمرير الـ data الراجعة من الـ API مباشرة إلى الـ Model لإنشاء الكائن بأمان
        final profile = ProfileModel.fromJson(result['data']);

        // 2. تحديث المتغيرات التفاعلية باستخدام بيانات الـ Model
        fullName.value = profile.name ?? fullName.value;
        email.value = profile.email ?? email.value;
        phone.value = profile.phone ?? phone.value;

        // إذا كان هناك حقول إضافية خارج الـ Model مثل الشركة نقرأها من الـ Map مباشرة كالمعتاد
        companyName.value = result['data']['company_name'] ?? result['data']['company'] ?? "Precision Wheels Luxury Rentals";

        // 3. معالجة رابط الصورة المأخوذ من الـ Model الاحترافي الخاص بكِ
        String? rawImage = profile.image;
        if (rawImage != null && rawImage.trim().isNotEmpty) {
          String cleanPath = rawImage.trim();
          String baseUrl = "https://reload-hug-monastery.ngrok-free.dev";

          if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
            profileImageUrl.value = "$cleanPath?t=${DateTime.now().millisecondsSinceEpoch}";
          } else {
            // تنظيف السلاش المتكرر في البداية والنهاية
            if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);

            // التعامل الاحترافي مع مجلد storage لضمان عدم تكراره أو نسيانه
            if (cleanPath.startsWith('storage/')) {
              profileImageUrl.value = "$baseUrl/$cleanPath?t=${DateTime.now().millisecondsSinceEpoch}";
            } else {
              profileImageUrl.value = "$baseUrl/storage/$cleanPath?t=${DateTime.now().millisecondsSinceEpoch}";
            }
          }
          debugPrint("✅ Parsed Profile Image URL from Model: ${profileImageUrl.value}");
        } else {
          profileImageUrl.value = null;
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateField(String key, String val, RxString obs) async {
    if (val == obs.value) return;
    try {
      isLoading.value = true;

      // هنا نقوم بإنشاء كائن مؤقت من الـ Model ونحوله إلى JSON توافقاً مع معايير الـ Architecture
      Map<String, dynamic> updateData = {key: val};
      if (key == 'phone') updateData = {'phone': val, 'phone_number': val};

      final result = await ProfileService.updateProfileFields(updateData);
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
      localImageFile.value = file; // عرض فوري للمستخدم للمرونة والاحترافية
      try {
        isLoading.value = true;
        final result = await ProfileService.uploadProfileImage(file);
        if (result['success'] == true) {
          await fetchProfile(); // جلب البيانات المحدثة وتحديث الـ Model
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

  Future<void> deleteImage() async {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Photo"),
        content: const Text("Are you sure you want to remove your profile picture?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                isLoading.value = true;
                final result = await ProfileService.deleteProfileImage();
                if (result['success'] == true) {
                  profileImageUrl.value = null;
                  localImageFile.value = null;
                  Get.snackbar("Deleted", "Profile photo removed", backgroundColor: Colors.green, colorText: Colors.white);
                } else {
                  Get.snackbar("Error", result['message'] ?? "Delete failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
                }
              } finally {
                isLoading.value = false;
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> updatePassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    try {
      isLoading.value = true;
      final result = await ProfileService.updatePassword(
        currentPassword: currentPasswordController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
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


}
class ProfileSittingScreen extends StatelessWidget {
  const ProfileSittingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ProfileController is initialized as permanent to be shared across screens
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);


    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text("Profile Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp),
            ),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 32.h),

                // Avatar الرئيسي
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ProfileAvatar(radius: 55.r, fontSize: 36.sp),
                      GestureDetector(
                        onTap: () => controller.pickAndUploadImage(),
                        onLongPress: () => controller.deleteImage(),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),
                Text(controller.fullName.value, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 32.h),

                CustomEditableCard(
                  label: "Full Name",
                  value: controller.fullName.value,
                  onSave: (val) => controller.updateField('name', val, controller.fullName),
                ),
                SizedBox(height: 16.h),
                CustomEditableCard(
                  label: "Email Address",
                  value: controller.email.value,
                  onSave: (val) => controller.updateField('email', val, controller.email),
                ),
                SizedBox(height: 16.h),
                CustomEditableCard(
                  label: "Phone Number",
                  value: controller.phone.value,
                  onSave: (val) => controller.updateField('phone', val, controller.phone),
                ),
                SizedBox(height: 16.h),
                CustomEditableCard(
                  label: "COMPANY NAME",
                  value: controller.companyName.value,
                  isEditable: false,
                  onSave: (val) {},
                ),

                SizedBox(height: 24.h),
                CustomProfileTile(
                  leadingPath: "assets/icons/ChangePasswordicon.svg",
                  title: "Change Password",
                  subtitle: "",
                  showCard: true,
                  onTap: () => _showPasswordBottomSheet(context, controller),
                ),

                SizedBox(height: 32.h),
                CustomButton(
                  text: "Logout",
                  icon: Icons.logout,
                  onTap: () => controller.confirmLogout(context),
                  backgroundColor: const Color(0xFFF9F0F0),
                  textColor: const Color(0xFFBA1A1A),
                  width: 310.w,
                  height: 56.h,
                  borderRadius: 16.r,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          if (controller.isLoading.value)
            Container(color: Colors.white.withOpacity(0.5), child: const Center(child: CircularProgressIndicator())),
        ],
      )),
    );
  }

  void _showPasswordBottomSheet(BuildContext context, ProfileController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Update Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              CustomTextField(hint: "Current Password", isPassword: true, controller: controller.currentPasswordController),
              SizedBox(height: 12.h),
              CustomTextField(hint: "New Password", isPassword: true, controller: controller.passwordController),
              SizedBox(height: 12.h),
              CustomTextField(hint: "Confirm New Password", isPassword: true, controller: controller.confirmPasswordController),
              SizedBox(height: 24.h),
              CustomButton(text: "Change Password", onTap: () => controller.updatePassword(), width: double.infinity, height: 45.h),
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
