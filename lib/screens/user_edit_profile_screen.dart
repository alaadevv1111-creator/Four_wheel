import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/screens/user_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_textfield2.dart';
import '../widgets/image_upload_widget.dart';
import '../models/user_profile_model.dart';
import '../services/UserProfileService.dart';
import 'Profile_admin_sitting.dart';

// --- 1. User Edit Profile Controller ---
class UserEditProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseNumberController = TextEditingController();

  var profileImage = Rxn<File>();
  var profileImageUrl = "".obs;
  var licenseImagePath = "".obs;
  var isLicenseSelected = false.obs;
  var licenseError = false.obs;
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // جلب البيانات من السيرفر
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final result = await UserProfileService.getProfile();

      if (result['success'] == true) {
        final data = result['data'];
        final user = UserProfileModel.fromJson(data);

        fullNameController.text = user.name ?? "";
        emailController.text = user.email ?? "";
        phoneController.text = user.phoneNumber ?? user.phone ?? "";
        licenseNumberController.text = user.licenseNumber ?? "";

        profileImageUrl.value = _formatUrl(user.image) ?? "";

        String? licImg = _formatUrl(user.licenseImage);
        if (licImg != null) {
          licenseImagePath.value = licImg;
          isLicenseSelected.value = true;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  String? _formatUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return "https://reload-hug-monastery.ngrok-free.dev/storage/$path";
  }

  // اختيار الصورة
  Future<void> pickImage(bool isProfile) async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80
    );

    if (image != null) {
      if (isProfile) {
        profileImage.value = File(image.path);
      } else {
        licenseImagePath.value = image.path;
        isLicenseSelected.value = true;
        licenseError.value = false;
      }
    }
  }

  // حفظ التغييرات وإرسالها للسيرفر
  Future<void> saveProfileChanges() async {
    try {
      isLoading.value = true;

      final updatedProfile = UserProfileModel(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        licenseNumber: licenseNumberController.text.trim(),
      );

      final result = await UserProfileService.updateProfile(
        profile: updatedProfile,
        profileImage: profileImage.value,
        licenseImage: isLicenseSelected.value && !licenseImagePath.value.startsWith('http')
            ? File(licenseImagePath.value)
            : null,
      );

      if (result['success'] == true) {
        // تحديث البيانات في ProfileController لضمان تحديث UserProfileScreen
        if (Get.isRegistered<UserProfileController>()) {
          await Get.find<UserProfileController>().fetchProfile();
        }

        Get.back();
        Get.snackbar("Success", "Profile updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", result['message'] ?? "Update failed",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    licenseNumberController.dispose();
    super.onClose();
  }
}

// --- 2. User Edit Profile Screen ---
class UserEditProfileScreen extends StatelessWidget {
  const UserEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserEditProfileController());

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        backgroundColor: AppColor.mainBc,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("Edit profile",
            style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.fullNameController.text.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColor.cardprim2));
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  // قسم صورة البروفايل
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120.r,
                          height: 120.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4.r),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                          ),
                          child: ClipOval(
                            child: controller.profileImage.value != null
                                ? Image.file(controller.profileImage.value!, fit: BoxFit.cover)
                                : (controller.profileImageUrl.value.isNotEmpty
                                ? Image.network(controller.profileImageUrl.value, fit: BoxFit.cover)
                                : Container(color: Colors.grey[200], child: Icon(Icons.person, size: 50.sp))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.pickImage(true),
                          child: CircleAvatar(
                            radius: 18.r,
                            backgroundColor: AppColor.cardprim2,
                            child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // الحقول النصية
                  _buildCard(
                    title: "Personal Details",
                    children: [
                      _buildField("FULL NAME", controller.fullNameController),
                      _buildField("EMAIL ADDRESS", controller.emailController, type: TextInputType.emailAddress),
                      _buildField("PHONE NUMBER", controller.phoneController, type: TextInputType.phone),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildCard(
                    title: "Driving Credentials",
                    children: [
                      _buildLabel("DRIVER LICENSE IMAGE"),
                      ImageUploadWidget(
                        imagePath: controller.licenseImagePath,
                        isImageSelected: controller.isLicenseSelected,
                        error: controller.licenseError,
                        onTap: () => controller.pickImage(false),
                        width: double.infinity,
                        height: 160.h,
                      ),
                      SizedBox(height: 16.h),
                      _buildField("LICENSE NUMBER", controller.licenseNumberController),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    text: controller.isLoading.value ? "SAVING..." : "SAVE CHANGES",
                    onTap:() => controller.saveProfileChanges(),
                    gradient: const [AppColor.cardprim2, AppColor.cardprim],
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    text: "CANCEL",
                    onTap: () => Get.back(),
                    backgroundColor: const Color(0xFFF1F5F9),
                    textColor: AppColor.cardprim,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.manrope(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        CustomTextField(
          hint: label,
          controller: controller,
          backgroundColor: AppColor.mainBc,
          borderRadius: 12,
          keyboardType: type,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(label,
          style: GoogleFonts.manrope(fontSize: 11.sp, fontWeight: FontWeight.bold, color: AppColor.cardprim, letterSpacing: 1)),
    );
  }
}
