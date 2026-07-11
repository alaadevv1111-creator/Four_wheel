import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../models/accessory_model.dart';
import '../constants/colors.dart';
import '../widgets/custom_feature_card.dart';
import '../widgets/custom_button2.dart';
import 'place_order_screen.dart';
import 'favorites_screen.dart';

class UserAccessoryDetails extends StatelessWidget {
  final AccessoryModel accessory;

  const UserAccessoryDetails({super.key, required this.accessory});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الصورة العلوية مع Hero Animation
            Stack(
              children: [
                Hero(
                  tag: 'accessory_${accessory.id ?? accessory.name}',
                  child: Container(
                    width: double.infinity,
                    height: 400.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                    ),
                    child: _buildImage(),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCircleButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: () => Get.back(),
                        ),
                        // أيقونة القلب التفاعلية
                        Obx(() => _buildCircleButton(
                          icon: favoritesController.isAccessoryFavorite(accessory)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor: favoritesController.isAccessoryFavorite(accessory)
                              ? AppColor.favoriteRed
                              : AppColor.textMuted,
                          onTap: () => favoritesController.toggleAccessoryFavorite(accessory),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // قسم محتوى التفاصيل مع انحناء علوي
            Transform.translate(
              offset: Offset(0, -30.r),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.mainBc,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  // تم حذف boxShadow لإزالة الخط الفاصل (الظل) العلوي
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // التصنيف
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        accessory.category.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF57657A),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // اسم المنتج
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          accessory.name,
                          style: GoogleFonts.manrope(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // السعر الحالي
                    Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\$${accessory.price.toStringAsFixed(2)}',
                              style: GoogleFonts.manrope(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // الوصف
                    Text(
                      'Premium quality parts and accessories from FourWheels, designed for comfort, safety, and vehicle enhancement.',
                      style: GoogleFonts.manrope(
                        fontSize: 15.sp,
                        height: 1.6,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // شبكة المميزات (Features Grid) - البطاقات الأربعة كما في الصورة
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.2,
                      children: const [
                        CustomFeatureCard(
                          icon: Icons.verified_outlined,
                          title: 'Durability',
                          subtitle: 'Built to last a lifetime',
                        ),
                        CustomFeatureCard(
                          icon: Icons.precision_manufacturing_outlined,
                          title: 'Precision',
                          subtitle: 'Perfect OEM fitment',
                        ),
                        CustomFeatureCard(
                          icon: Icons.bolt_outlined,
                          title: 'Easy Install',
                          subtitle: 'Plug & Play design',
                        ),
                        CustomFeatureCard(
                          icon: Icons.add_moderator_outlined,
                          title: 'Safety',
                          subtitle: 'Tested for impact',
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // صندوق التنبيه الهام (Important Notice) - المحدث كما في الصورة
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F2),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFFDE2E2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFFB91C1C),
                            size: 22.sp,
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Important Notice",
                                    style: GoogleFonts.manrope(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFB91C1C),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Cash On Delivery Only. Online payment and credit cards are not supported at this time for high-value accessories.",
                                  style: GoogleFonts.manrope(
                                    fontSize: 13.sp,
                                    color: const Color(0xFFB91C1C),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // شريط السعر والطلب السفلي
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Total Price",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '\$${accessory.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Flexible(
                          flex: 1,
                          child: CustomButton(
                            text: "Order Now",
                            height: 56.h,
                            width: double.infinity,
                            gradient: const [AppColor.cardprim2, AppColor.cardprim],
                            borderRadius: 12,
                            onTap: () => Get.to(() => PlaceOrderScreen(accessory: accessory)),
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
    );
  }

  Widget _buildImage() {
    if (accessory.photoUrl == null || accessory.photoUrl!.isEmpty) {
      return Icon(Icons.image_not_supported_outlined, size: 60.r, color: Colors.grey[400]);
    }
    return Image.network(
      accessory.photoUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported_outlined, size: 60.r, color: Colors.grey[400]),
    );
  }

  Widget _buildCircleButton({required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor ?? AppColor.primary, size: 20.r),
      ),
    );
  }
}