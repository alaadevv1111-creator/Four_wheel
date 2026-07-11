import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../widgets/accessory_card.dart';
import '../widgets/car_rental_card.dart';
import '../models/accessory_model.dart';
import '../services/UserAccessoryService.dart';
import 'user_accessory_details.dart';
import 'package:four_wheels/models/user_cardetilesModel.dart';

// --- Favorites Controller ---
// ---1. Favorites Controller (Logic & API Binding) ---
class FavoritesController extends GetxController {
  var favoriteAccessories = <AccessoryModel>[].obs;
  var favoriteCars = <CarDetailsModel>[].obs;   // بدّلي هون



  bool isCarFavorite(CarDetailsModel car) =>
      favoriteCars.any((item) => item.id == car.id);   // بدّلي name بـ id (أدق وأضمن)

  void toggleCarFavorite(CarDetailsModel car) {
    if (isCarFavorite(car)) {
      favoriteCars.removeWhere((item) => item.id == car.id);
    } else {
      favoriteCars.add(car);
    }
  }
  var isLoading = false.obs;
  var selectedTabIndex = 0.obs; // 0 للكل، 1 للسيارات، 2 للإكسسوارات

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  // جلب المفضلات من السيرفر
  Future<void> fetchFavorites() async {
    try {
      isLoading.value = true;
      final response = await UserAccessoryService.getFavorites();
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        favoriteAccessories.assignAll(
          data.map((json) => AccessoryModel.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      debugPrint("❌ Error fetching favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // التحقق هل الملحق موجود في المفضلة
  bool isAccessoryFavorite(AccessoryModel accessory) {
    return favoriteAccessories.any((item) => item.id == accessory.id);
  }

  // إضافة أو حذف الملحق مع معالجة الأخطاء والتراجع (Rollback)
  Future<void> toggleAccessoryFavorite(AccessoryModel accessory) async {
    if (accessory.id == null) return;

    final bool currentlyFavorite = isAccessoryFavorite(accessory);

    // 1. تحديث الواجهة فوراً (Optimistic UI)
    if (currentlyFavorite) {
      favoriteAccessories.removeWhere((item) => item.id == accessory.id);
      Get.snackbar(
        "Favorites",
        "Removed from favorites",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } else {
      favoriteAccessories.add(accessory);
      Get.snackbar(
        "Favorites",
        "Added to favorites",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.cardprim2,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }

    try {
      // 2. محاولة التحديث في السيرفر
      final response = currentlyFavorite
          ? await UserAccessoryService.removeFromFavorites(accessory.id!)
          : await UserAccessoryService.addToFavorites(accessory.id!);

      // 3. التحقق من نجاح العملية
      if (response['success'] != true) {
        // إذا فشل الطلب، نتراجع عن التغيير المحلي ونعيد الحالة كما كانت
        if (currentlyFavorite) {
          favoriteAccessories.add(accessory);
        } else {
          favoriteAccessories.removeWhere((item) => item.id == accessory.id);
        }

        // تنبيه المستخدم بالفشل
        Get.snackbar(
          "Favorites",
          response['message'] ?? "Failed to update favorites",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // 4. معالجة أخطاء الاتصال المفاجئة (Rollback)
      if (currentlyFavorite) {
        favoriteAccessories.add(accessory);
      } else {
        favoriteAccessories.removeWhere((item) => item.id == accessory.id);
      }
      debugPrint("❌ Toggle Favorite Error: $e");
    }
  }

  // منطق تبديل التبويبات
  void changeTab(int index) => selectedTabIndex.value = index;

  // --- منطق السيارات (نفس الطريقة ستطبق عند توفر الـ API) ---

}
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        backgroundColor: AppColor.mainBc,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "My Favorites",
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أزرار التصنيف (الكل، سيارات، إكسسوارات)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Obx(() => Row(
              children: [
                _buildFilterButton("All", 0, controller),
                SizedBox(width: 8.w),
                _buildFilterButton("Cars", 1, controller),
                SizedBox(width: 8.w),
                _buildFilterButton("Accessories", 2, controller),
              ],
            )),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColor.primary));
              }

              if (controller.favoriteCars.isEmpty && controller.favoriteAccessories.isEmpty) {
                return _buildEmptyState("No favorites yet");
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchFavorites(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // عرض السيارات
                    if (controller.selectedTabIndex.value == 0 || controller.selectedTabIndex.value == 1)
                      _buildCarsSliver(controller),

                    // مسافة فاصلة بين الأقسام في تبويب "الكل"
                    if (controller.selectedTabIndex.value == 0 && controller.favoriteCars.isNotEmpty && controller.favoriteAccessories.isNotEmpty)
                      SliverToBoxAdapter(child: SizedBox(height: 24.h)),

                    // عرض الإكسسوارات
                    if (controller.selectedTabIndex.value == 0 || controller.selectedTabIndex.value == 2)
                      _buildAccessoriesSliver(controller),

                    SliverToBoxAdapter(child: SizedBox(height: 40.h)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, int index, FavoritesController controller) {
    final isSelected = controller.selectedTabIndex.value == index;
    return GestureDetector(
      onTap: () => controller.selectedTabIndex.value = index,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF131B2E) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0)),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildCarsSliver(FavoritesController controller) {
    if (controller.favoriteCars.isEmpty) {
      if (controller.selectedTabIndex.value == 1) {
        return SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState("No favorite cars"));
      }
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final car = controller.favoriteCars[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: CarRentalCard(
                imageUrl: car.image,
                carName: car.name,
                price: car.pricePerDay,
                rating: car.rating?.toStringAsFixed(1) ?? "5.0",
                reviewsCount: car.reviewsCount?.toString() ?? "0",
                isAvailable: car.isAvailable,
                isFavorite: true,
                onFavoriteTap: () => controller.toggleCarFavorite(car),
                onViewDetails: () {},
              ),
            );
          },
          childCount: controller.favoriteCars.length,
        ),
      ),
    );
  }

  Widget _buildAccessoriesSliver(FavoritesController controller) {
    if (controller.favoriteAccessories.isEmpty) {
      if (controller.selectedTabIndex.value == 2) {
        return SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState("No favorite accessories"));
      }
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          mainAxisExtent: 355.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final acc = controller.favoriteAccessories[index];
            return AccessoryCard(
              imageUrl: acc.photoUrl ?? "",
              title: acc.name,
              price: "\$${acc.price.toStringAsFixed(2)}",
              isFavorite: true,
              onFavoriteTap: () => controller.toggleAccessoryFavorite(acc),
              onTap: () => Get.to(() => UserAccessoryDetails(accessory: acc)),
              onViewDetails: () => Get.to(() => UserAccessoryDetails(accessory: acc)),
              averageRating: acc.averageRating,
            );
          },
          childCount: controller.favoriteAccessories.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 60.sp, color: const Color(0xFFE2E8F0)),
          SizedBox(height: 16.h),
          Text(message, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          SizedBox(height: 4.h),
          Text("Items you like will appear here.", style: GoogleFonts.manrope(fontSize: 13.sp, color: const Color(0xFF64748B))),
        ],
      ),
    );
  }
}
