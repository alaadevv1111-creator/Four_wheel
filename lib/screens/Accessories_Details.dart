import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/accessory_model.dart';
import '../services/AccessoryService.dart';
import '../widgets/ProfileAvatar.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/info_card.dart';
import '../widgets/accessory_helper_widgets.dart';
import 'Edit_Accessories.dart';
import 'General_admin_sitting.dart';
import 'Accessories.dart'; // استيراد للوصول لـ AccController

class AccessoriesDetailsController extends GetxController {
  final int accessoryId;
  var isLoading = true.obs;
  var accessory = Rxn<AccessoryModel>();

  AccessoriesDetailsController(this.accessoryId);

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      isLoading.value = true;
      final response = await AccessoryService.getAccessoryDetails(accessoryId);
      if (response['success'] == true) {
        accessory.value = AccessoryModel.fromJson(response['data']);
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to load details",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint("Error fetching accessory details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Color getStatusColor() {
    String status = (accessory.value?.status ?? "").toLowerCase();
    if (status.contains("in stock")) return const Color(0xFF10B981);
    if (status.contains("low")) return const Color(0xFFEF4444);
    return const Color(0xFF6B7280);
  }

  /// دالة الحذف الفعلية المحدثة لتعمل على تحديث القائمة الرئيسية فوراً
  Future<void> deleteItem() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: AppColor.primary)),
        barrierDismissible: false,
      );

      final response = await AccessoryService.deleteAccessory(accessoryId);
      Get.back(); // إغلاق مؤشر التحميل

      if (response['success'] == true) {
        // 1. العودة للشاشة السابقة (قائمة الإكسسوارات)
        Get.back();

        // 2. تحديث القائمة الرئيسية فوراً باستخدام Get.find
        if (Get.isRegistered<AccController>()) {
          Get.find<AccController>().refreshData();
        }

        Get.snackbar(
          "Deleted",
          response['message'] ?? "Item removed successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to delete item",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back();
      debugPrint("Error during deletion: $e");
    }
  }
}

class AccessoriesDetails extends StatelessWidget {
  final int id;
  const AccessoriesDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccessoriesDetailsController(id));

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.secondary,
        toolbarHeight: 72.h,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
        ),
        title: Text(
          'Accessories Details',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.45,
            color: const Color(0xff0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final acc = controller.accessory.value;
          if (acc == null) {
            return const Center(child: Text("Accessory not found"));
          }

          final statusColor = controller.getStatusColor();
          final String formattedAssetValue = (acc.assetValue ?? 0.0)
              .toStringAsFixed(2)
              .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},');

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Container(
                    width: 342.w,
                    height: 213.75.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomImageView(
                            imagePath: acc.photoUrl,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        Positioned(
                          top: 16.h,
                          right: 16.w,
                          child: Row(
                            children: [
                              AccessoryBadge(
                                text: acc.category.toUpperCase(),
                                bgColor: Colors.white,
                                textColor: const Color(0xFF131B2E),
                              ),
                              SizedBox(width: 8.w),
                              AccessoryBadge(
                                text: (acc.status ?? "IN STOCK").toUpperCase(),
                                bgColor: statusColor.withOpacity(0.1),
                                textColor: statusColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  acc.name,
                  style: GoogleFonts.manrope(
                    fontSize: 36.sp,
                    color: Colors.black,
                    letterSpacing: -0.9,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.qr_code_2_rounded,
                        size: 18.sp, color: AppColor.bcolorsmalltitle),
                    SizedBox(width: 6.w),
                    Text(
                      acc.partId ?? "N/A",
                      style: AccessoryStyles.valueStyle14
                          .copyWith(color: AppColor.bcolorsmalltitle),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    InfoCard(
                      title: "INVENTORY",
                      value: acc.stockQuantity.toString(),
                      unit: acc.unitName ?? "units",
                    ),
                    SizedBox(width: 16.w),
                    InfoCard(
                      title: "UNIT PRICE",
                      value: acc.price.toStringAsFixed(2),
                      isPrice: true,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: 342.w,
                  height: 128.h,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: AppColor.backhedar,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ASSET VALUE", style: AccessoryStyles.labelStyle),
                      Text(
                        "\$$formattedAssetValue",
                        style: GoogleFonts.manrope(
                          fontSize: 24.sp,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                CustomButton(
                  text: "Edit Item",
                  icon: Icons.edit_outlined,
                  width: 342.w,
                  height: 68.h,
                  gradient: const [AppColor.cardprim2, AppColor.cardprim],
                  onTap: () async {
                    // الانتظار حتى عودة المستخدم من صفحة التعديل لتحديث البيانات
                    await Get.to(() => EditAccessories(data: acc.toJson()));
                    controller.fetchDetails();
                  },
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: "Delete Item",
                  icon: Icons.delete_outline_rounded,
                  width: 342.w,
                  height: 68.h,
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF991B1B),
                  borderColor: AppColor.secondary2,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => DeleteConfirmationDialog(
                      onDelete: controller.deleteItem,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
