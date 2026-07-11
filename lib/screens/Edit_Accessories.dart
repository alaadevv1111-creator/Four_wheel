import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../models/accessory_model.dart';
import '../services/AccessoryService.dart';
import '../widgets/ProfileAvatar.dart';
import '../widgets/custom_button2.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/accessory_helper_widgets.dart';
import '../widgets/custom_section_card.dart';
import '../widgets/custom_image_view.dart';
import 'Accessories.dart';
import 'General_admin_sitting.dart';
import 'Profile_admin_sitting.dart';

// --- Controller القديم المعتمد مع تأمين قراءة المفاتيح المحتملة ---
class EditAccessoriesController extends GetxController {
  final Map<String, dynamic> data;
  EditAccessoriesController(this.data);

  var selectedImagePath = ''.obs;
  var isImageSelected = false.obs;
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController itemNameController;
  late TextEditingController priceController;
  var quantity = 0.obs;
  var category = "Spare Parts".obs;
  late String sku;
  late int unitId;

  final List<String> categories = ["Spare Parts", "Accessories"];

  @override
  void onInit() {
    super.onInit();

    // تأمين جلب اسم العنصر سواء جاء بـ name أو item_name لضمان تعبئة الحقل
    String initialName = data['name']?.toString() ?? data['item_name']?.toString() ?? "";
    itemNameController = TextEditingController(text: initialName);

    // جلب السعر وتحويله لنص
    priceController = TextEditingController(text: (data['price'] ?? "0.00").toString());

    // تأمين جلب الكمية سواء جاءت بـ stock_quantity أو quantity
    var initialQty = data['stock_quantity'] ?? data['quantity'] ?? 0;
    quantity.value = int.tryParse(initialQty.toString()) ?? 0;

    // تأمين جلب الـ SKU أو الـ Part ID
    sku = data['part_id']?.toString() ?? data['sku']?.toString() ?? "N/A";

    // جلب الـ unit_id
    unitId = data['unit_id'] ?? 4;

    // جلب الفئة وتأمين مطابقتها مع العناصر الموجودة بالقائمة
    String initialCat = data['category']?.toString() ?? "Spare Parts";
    if (initialCat == "Spare Part") initialCat = "Spare Parts";
    if (initialCat == "ACCESSORY" || initialCat == "Accessory") initialCat = "Accessories";
    category.value = categories.contains(initialCat) ? initialCat : categories.first;

    // جلب رابط الصورة وعرضها مسبقاً في الواجهة
    String? initialImage = data['photo_url'] ?? data['imageUrl'] ?? data['image_url'];
    if (initialImage != null && initialImage.isNotEmpty) {
      selectedImagePath.value = initialImage;
      isImageSelected.value = true;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImagePath.value = image.path;
        isImageSelected.value = true;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  Future<void> saveChanges() async {
    if (itemNameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // استخدام البناء الأصلي للموديل كما طلبتِ تماماً
      final updatedModel = AccessoryModel(
        name: itemNameController.text.trim(),
        category: category.value,
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
        stockQuantity: quantity.value,
        unitId: unitId,
      );

      final String? finalPhotoPath = selectedImagePath.value.isNotEmpty && !selectedImagePath.value.startsWith('http')
          ? selectedImagePath.value
          : null;

      final result = await AccessoryService.updateAccessory(
        data['id'] ?? 0,
        updatedModel,
        photoPath: finalPhotoPath, // تمرير المسار الذكي المفلتر
      );

      if (result['success'] == true) {
        if (Get.isRegistered<AccController>()) {
          final accController = Get.find<AccController>();
          int index = accController.itemsList.indexWhere((item) => item['id'] == data['id']);
          if (index != -1) {
            // تحديث محلي فوري بالأسماء التي تعتمد عليها الواجهة الرئيسية
            accController.itemsList[index] = {
              ...accController.itemsList[index],
              'name': itemNameController.text.trim(),
              'item_name': itemNameController.text.trim(),
              'price': double.tryParse(priceController.text.trim()) ?? 0.0,
              'stock_quantity': quantity.value,
              'quantity': quantity.value,
              'category': category.value,
              'status': AccessoryUtils.calculateStatus(quantity.value),
              // إذا لم نرفع صورة جديدة (null)، نحتفظ بالرابط القديم الموجود في الـ data الأصلية
              'photo_url': finalPhotoPath ?? data['photo_url'] ?? data['imageUrl'] ?? data['image_url'],
              'imageUrl': finalPhotoPath ?? data['photo_url'] ?? data['imageUrl'] ?? data['image_url'],
              'last_modified': AccessoryUtils.formattedTodayDate,
            };
            accController.itemsList.refresh();
          }
        }
        Get.back();
        Get.snackbar("Success",  "Updated successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error",  "Update failed",
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Update failed", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    itemNameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}

// --- UI View الشاشة بالتصميم الفخم متناسقة مع الكنترولر القديم ---
class EditAccessories extends StatelessWidget {
  final Map<String, dynamic> data;
  const EditAccessories({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditAccessoriesController(data));
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Edit Accessories',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            letterSpacing: -0.45,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp,),
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
                SizedBox(height: 10.h),
                Container(
                  width: 342.w, height: 192.38.h,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 342.w, height: 192.38.h,
                            child: ImageUploadWidget(
                              imagePath: c.selectedImagePath,
                              isImageSelected: c.isImageSelected,
                              error: false.obs,
                              width: 342.w,
                              height: 192.38.h,
                              onTap: () => AccessoryImagePicker.showSourceSheet(context: context, onImageSelected: c.pickImage),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AccessoryInfoColumn(label: "CURRENT PART ID", value: c.sku),
                    AccessoryInfoColumn(label: "LAST MODIFIED", value: AccessoryUtils.formattedTodayDate, crossAxisAlignment: CrossAxisAlignment.end),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomSectionCard(
                  children: [
                    SectionTextField(label: "Item Name", hintText: "Name", controller: c.itemNameController),
                    SectionDropdownField(label: "Category", rxValue: c.category, options: c.categories),

                    Text("QUANTITY", style: AccessoryStyles.labelStyle),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(color: AppColor.backhedar, borderRadius: BorderRadius.circular(32.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: Icon(Icons.remove, size: 20.sp, color: Colors.black), onPressed: () { if (c.quantity.value > 0) c.quantity.value--; }),
                          Obx(() => Text(c.quantity.value.toString(), style: AccessoryStyles.boldValueStyle)),
                          IconButton(icon: Icon(Icons.add, size: 20.sp, color: Colors.black), onPressed: () => c.quantity.value++),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SectionTextField(
                      label: "Price (USD)", hintText: "0.00",
                      controller: c.priceController, keyboardType: TextInputType.number,
                      prefix: Text("\$ ", style: AccessoryStyles.boldValueStyle),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                CustomButton(text: "Save Changes", width: 342.w, height: 68.h, gradient: const [AppColor.cardprim2, AppColor.cardprim], onTap: () => c.saveChanges()),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: 342.w, height: 68.h,
                    child: Center(child: Text("Cancel", style: AccessoryStyles.boldValueStyle.copyWith(color: AppColor.bcolorsmalltitle))),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          // مؤشر الحفظ المزامر مع الـ API
          if (c.isLoading.value)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator(color: AppColor.cardprim)),
            )
        ],
      )),
    );
  }
}