import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../models/accessory_model.dart';
import '../constants/colors.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_textfield2.dart';
import '../services/UserAccessoryService.dart';
import 'order_success_screen.dart';
import 'user_profile_screen.dart';

class PlaceOrderController extends GetxController {
  final AccessoryModel accessory;
  PlaceOrderController({required this.accessory});

  var quantity = 1.obs;
  var isLoading = false.obs;

  // الحقول النصية المطلوبة للطلب
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController(); // سأجلب بياناته من البروفايل للتوثيق
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _prefillUserData();
  }

  // سحب البيانات المتوفرة من بروفايل المستخدم
  void _prefillUserData() {
    if (Get.isRegistered<UserProfileController>()) {
      final userProfile = Get.find<UserProfileController>();
      fullNameController.text = userProfile.fullName.value;
      phoneController.text = userProfile.phone.value;
      emailController.text = userProfile.email.value;
    }
  }

  // التحقق من أن جميع الحقول المطلوبة ممتلئة (ما عدا الملاحظات)
  bool validateForm() {
    if (fullNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty) {
      Get.snackbar(
        "Required Fields",
        "Please fill in your name, phone, address, and city to proceed.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.r),
      );
      return false;
    }
    return true;
  }

  // --- دالة إرسال الطلب للـ API المحدثة ---
  Future<void> submitOrder() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      // تجهيز البيانات بالصيغة التي يطلبها الـ API
      final Map<String, dynamic> orderData = {
        'full_name': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'notes': notesController.text.trim(),
        'quantity': quantity.value,
      };

      // استدعاء السيرفز باستخدام id الإكسسوار
      final result = await UserAccessoryService.placeOrder(accessory.id!, orderData);

      if (result['success'] == true) {
        final now = DateTime.now();
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final dateString = "${months[now.month - 1]} ${now.day}, ${now.year}";

        // الانتقال لصفحة النجاح في حال تم الطلب
        Get.off(() => OrderSuccessScreen(accessory: accessory, orderDate: dateString));
      } else {
        Get.snackbar(
          "Order Failed",
          result['message'] ?? "Failed to place order. Please try again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Check your internet connection.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void increment() {
    if (quantity.value < accessory.stockQuantity) {
      quantity.value++;
    }
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double get totalPrice => accessory.price * quantity.value;

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    notesController.dispose();
    super.onClose();
  }
}

class PlaceOrderScreen extends StatelessWidget {
  final AccessoryModel accessory;
  const PlaceOrderScreen({super.key, required this.accessory});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlaceOrderController(accessory: accessory));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Place Order",
          style: GoogleFonts.manrope(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة المنتج المحدثة (Flush Image)
                Container(
                  height: 130.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            bottomLeft: Radius.circular(20.r),
                          ),
                          child: accessory.photoUrl != null && accessory.photoUrl!.isNotEmpty
                              ? Image.network(
                            accessory.photoUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => _buildDefaultCarImage(),
                          )
                              : _buildDefaultCarImage(),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "PREMIUM ACCESSORY",
                                style: GoogleFonts.manrope(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                accessory.name,
                                style: GoogleFonts.manrope(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF131B2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$${accessory.price.toStringAsFixed(2)}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "\$${(accessory.price * 1.2).toStringAsFixed(2)}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFCBD5E1),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                _buildSectionHeader(Icons.person_outline, "Delivery Contact"),
                SizedBox(height: 16.h),
                _buildFieldLabel("Full Name", isRequired: true),
                CustomTextField(
                  hint: "Full Name",
                  backgroundColor: const Color(0xFFF1F3F5),
                  borderRadius: 12,
                  height: 48.h,
                  controller: controller.fullNameController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel("Email Address (Synced)", isRequired: true),
                CustomTextField(
                  hint: "Email Address",
                  backgroundColor: const Color(0xFFF1F3F5),
                  borderRadius: 12,
                  height: 48.h,
                  controller: controller.emailController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel("Phone Number", isRequired: true),
                CustomTextField(
                  hint: "Phone Number",
                  backgroundColor: const Color(0xFFF1F3F5),
                  borderRadius: 12,
                  height: 48.h,
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                ),

                SizedBox(height: 24.h),
                _buildSectionHeader(Icons.location_on_outlined, "Address Details"),
                SizedBox(height: 16.h),
                _buildFieldLabel("Street Address", isRequired: true),
                CustomTextField(
                  hint: "Street, Apartment or Suite",
                  backgroundColor: const Color(0xFFF1F3F5),
                  borderRadius: 12,
                  height: 48.h,
                  controller: controller.addressController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel("City", isRequired: true),
                CustomTextField(
                  hint: "City",
                  backgroundColor: const Color(0xFFF1F3F5),
                  borderRadius: 12,
                  height: 48.h,
                  controller: controller.cityController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel("Additional Notes (Optional)"),
                CustomTextField(
                  hint: "Special delivery instructions...",
                  backgroundColor: const Color(0xFFF1F3F5),
                  borderRadius: 12,
                  maxLines: 3,
                  controller: controller.notesController,
                ),

                SizedBox(height: 24.h),
                // ملخص الطلب
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Quantity", style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
                          Obx(() => Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
                            child: Row(
                              children: [
                                _buildQtyBtn(Icons.remove, controller.decrement, color: controller.quantity.value <= 1 ? Colors.grey : Colors.black),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Text("${controller.quantity.value}", style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                                ),
                                _buildQtyBtn(Icons.add, controller.increment, color: controller.quantity.value >= accessory.stockQuantity ? Colors.grey : Colors.black),
                              ],
                            ),
                          )),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildSummaryRow("Base Price", "\$${accessory.price.toStringAsFixed(2)}"),
                      SizedBox(height: 12.h),
                      _buildSummaryRow("Standard Delivery", "COMPLIMENTARY"),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price", style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                          Obx(() => Text("\$${controller.totalPrice.toStringAsFixed(2)}", style: GoogleFonts.manrope(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.black))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // طريقة الدفع
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8.r)),
                            child: Icon(Icons.payments_outlined, color: Colors.white, size: 20.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cash On Delivery", style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                Text("Default payment method", style: GoogleFonts.manrope(fontSize: 11.sp, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.radio_button_checked, color: Colors.black),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "Payment is made only when receiving the product. Online payments are not available.",
                                style: GoogleFonts.manrope(fontSize: 11.sp, color: const Color(0xFF64748B), height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                Obx(() => CustomButton(
                  text: controller.isLoading.value ? "Processing..." : "Confirm Order",
                  icon: controller.isLoading.value ? null : Icons.arrow_forward,
                  gradient: const [AppColor.cardprim2, AppColor.cardprim],
                  borderRadius: 12,
                  onTap:  () => controller.submitOrder(),
                )),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    "SECURE TRANSACTION BY FOUR WHEELS",
                    style: GoogleFonts.manrope(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFCBD5E1),
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
          Obx(() => controller.isLoading.value
              ? Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildDefaultCarImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF1F5F9),
      child: Icon(
        Icons.directions_car_filled_outlined,
        size: 45.sp,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) => Row(
    children: [
      Icon(icon, size: 18.sp, color: const Color(0xFF1E293B)),
      SizedBox(width: 8.w),
      Text(title, style: GoogleFonts.manrope(fontSize: 15.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B))),
    ],
  );

  Widget _buildFieldLabel(String label, {bool isRequired = false}) => Padding(
    padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
    child: Row(
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
        if (isRequired)  Text(" *", style: TextStyle(color: Colors.red, fontSize: 13.sp)),
      ],
    ),
  );

  Widget _buildSummaryRow(String title, String value) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.manrope(fontSize: 13.sp, color: const Color(0xFF64748B))),
        Text(value, style: GoogleFonts.manrope(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    ),
  );

  Widget _buildQtyBtn(IconData icon, VoidCallback? onTap, {Color color = Colors.black}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.r),
      child: Icon(icon, size: 18.sp, color: color),
    ),
  );
}