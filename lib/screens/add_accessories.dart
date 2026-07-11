import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../widgets/ProfileAvatar.dart';
import '../widgets/custom_section_card.dart';
import '../widgets/custom_button2.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/accessory_helper_widgets.dart';
import '../services/AuthService.dart';
import 'Accessories_Details.dart';
import 'Accessories.dart';
import 'General_admin_sitting.dart';
import 'Profile_admin_sitting.dart';

class AddAccessoriesController extends GetxController {
  var selectedImagePath = ''.obs;
  var isImageSelected = false.obs;
  var imageError = false.obs;
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  final itemName = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();

  final itemNameFocus = FocusNode();
  final priceFocus = FocusNode();
  final quantityFocus = FocusNode();

  var category = "Spare Parts".obs;
  var status = "In Stock".obs;
  var isTracking = true.obs;

  var itemNameError = RxnString();
  var priceError = RxnString();
  var quantityError = RxnString();

  final categories = ["Spare Parts", "Accessories"];
  final unitsList = ["units", "sets", "Ltr", "pcs"];

  @override
  void onInit() {
    super.onInit();
    itemNameFocus.addListener(() { if (!itemNameFocus.hasFocus) _validateItemName(); });
    priceFocus.addListener(() { if (!priceFocus.hasFocus) _validatePrice(); });
    quantityFocus.addListener(() { if (!quantityFocus.hasFocus) _validateQuantity(); });

    itemName.addListener(() => _clearError(itemName, itemNameError));
    price.addListener(() => _clearError(price, priceError));
    quantity.addListener(() => _clearError(quantity, quantityError));
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImagePath.value = image.path;
        isImageSelected.value = true;
        imageError.value = false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  void _clearError(TextEditingController controller, RxnString errorRx) {
    if (controller.text.trim().isNotEmpty) errorRx.value = null;
  }

  void _validateItemName() {
    itemNameError.value = itemName.text.trim().isEmpty ? "Item name is required" : null;
  }

  void _validatePrice() {
    final text = price.text.trim();
    if (text.isEmpty) {
      priceError.value = "Price is required";
    } else if (double.tryParse(text) == null) {
      priceError.value = "Enter a valid number";
    } else {
      priceError.value = null;
    }
  }

  void _validateQuantity() {
    final text = quantity.text.trim();
    if (text.isEmpty) {
      quantityError.value = "Quantity is required";
    } else {
      final match = RegExp(r'^(\d+)').firstMatch(text);
      if (match == null) {
        quantityError.value = "Please enter a valid number";
      } else {
        quantityError.value = null;
      }
    }
  }

  bool validateAll() {
    _validateItemName();
    _validatePrice();
    _validateQuantity();
    imageError.value = !isImageSelected.value;

    return itemNameError.value == null &&
        priceError.value == null &&
        quantityError.value == null &&
        isImageSelected.value;
  }

  void clearFields() {
    itemName.clear(); price.clear(); quantity.clear();
    selectedImagePath.value = ''; isImageSelected.value = false;
    itemNameError.value = null; priceError.value = null; quantityError.value = null;
    imageError.value = false;
  }

  Future<void> saveOrUpdate() async {
    if (!validateAll()) return;

    final match = RegExp(r'^(\d+)\s*(.*)$').firstMatch(quantity.text.trim());
    final int qtyValue = int.tryParse(match?.group(1) ?? '0') ?? 0;

    final String selectedUnitText = (match?.group(2)?.trim().isNotEmpty ?? false)
        ? match!.group(2)!.trim()
        : unitsList.last;

    int unitId = unitsList.indexOf(selectedUnitText) + 1;
    if (unitId <= 0) unitId = 4;

    try {
      isLoading.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: AppColor.cardprim)),
        barrierDismissible: false,
      );

      final url = Uri.parse('https://reload-hug-monastery.ngrok-free.dev/api/v1/accessories/add');
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      });

      request.fields['name'] = itemName.text.trim();
      request.fields['price'] = price.text.trim();
      request.fields['stock_quantity'] = qtyValue.toString();
      request.fields['unit_id'] = unitId.toString();
      request.fields['category'] = category.value;

      if (selectedImagePath.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('photo', selectedImagePath.value));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      Get.back(); // إغلاق اللودينج
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // تحديث القائمة الرئيسية فوراً قبل الانتقال
        if (Get.isRegistered<AccController>()) {
          Get.find<AccController>().refreshData();
        }

        clearFields();
        // الانتقال لصفحة التفاصيل وإزالة صفحة الإضافة من المكدس
        Get.off(() => AccessoriesDetails(id: data['data']['id']));

        Get.snackbar("Success",  "Item added successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error",  "Failed to add item",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back();
      isLoading.value = false;
      Get.snackbar("Error", "Connection error: $e");
    }
  }

  @override
  void onClose() {
    itemName.dispose(); price.dispose(); quantity.dispose();
    itemNameFocus.dispose(); priceFocus.dispose(); quantityFocus.dispose();
    super.onClose();
  }
}

class AddAccessories extends StatelessWidget {
  const AddAccessories({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddAccessoriesController());
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
        ),
        title: Text(
          'Add Accessories',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.45,
            color: const Color(0xff0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(
                radius: 18.r,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 342.w,
              padding: EdgeInsets.all(36.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploadWidget(
                    imagePath: c.selectedImagePath,
                    isImageSelected: c.isImageSelected,
                    error: c.imageError,
                    onTap: () => AccessoryImagePicker.showSourceSheet(
                        context: context,
                        onImageSelected: c.pickImage
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Text("NEW ENTRY", style: AccessoryStyles.labelStyle),
                  SizedBox(height: 12.h),
                  Text("Inventory\nSpecification", style: GoogleFonts.poppins(fontSize: 30.sp, color: AppColor.cardprim2, height: 1.1, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15.h),
                  Text("Ensure all technical details are accurate for synchronization with the central automotive parts registry.",
                      style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColor.bcolorsmalltitle, height: 1.4)),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            CustomSectionCard(
              children: [
                Obx(() => SectionTextField(
                  label: "Item Name",
                  hintText: "e.g. Carbon Fiber Brake Disc",
                  controller: c.itemName,
                  focusNode: c.itemNameFocus,
                  isRequired: true,
                  errorText: c.itemNameError.value,
                )),
                SectionDropdownField(label: "Category", rxValue: c.category, options: c.categories, isRequired: true),
              ],
            ),
            CustomSectionCard(
              title: "Financial Details",
              icon: Icons.account_balance_wallet_outlined,
              children: [
                Obx(() => SectionTextField(
                  label: "Price (USD)",
                  hintText: "0.00",
                  isRequired: true,
                  controller: c.price,
                  focusNode: c.priceFocus,
                  errorText: c.priceError.value,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefix: Text("\$ ", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color:AppColor.bcolorsmalltitle )),
                )),
                Obx(() => SectionQuantityField(
                  label: "Quantity",
                  controller: c.quantity,
                  focusNode: c.quantityFocus,
                  units: c.unitsList,
                  errorText: c.quantityError.value,
                )),
              ],
            ),
            SizedBox(height: 32.h),
            Obx(() => CustomButton(
              text: c.isLoading.value ? "Saving..." : "Save Item",
              width: 342.w,
              height: 68.h,
              gradient: const [AppColor.cardprim2,AppColor.cardprim],
              onTap:  () => c.saveOrUpdate(),
            )),
            SizedBox(height: 12.h),
            CustomButton(
              text: "Cancel",
              width: 342.w,
              height: 68.h,
              backgroundColor: Colors.white,
              textColor: AppColor.primary,
              borderColor:AppColor.secondary2,
              onTap: () => Get.back(),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
