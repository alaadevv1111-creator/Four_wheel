import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../widgets/accessory_card.dart';
import '../widgets/custom_filter_button.dart';
import '../models/accessory_model.dart';
import '../services/UserAccessoryService.dart'; // تم تغيير الاستيراد هنا
import 'user_accessory_details.dart';
import 'favorites_screen.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';
class UserAccessoriesController extends GetxController {
  var selectedCategory = "all".obs;
  var searchQuery = "".obs;
  var accessories = <AccessoryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccessories();
  }

  // استخدام UserAccessoryService لجلب البيانات
  Future<void> fetchAccessories() async {
    try {
      isLoading.value = true;
      final response = await UserAccessoryService.getAllAccessories();
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        accessories.assignAll(data.map((json) => AccessoryModel.fromJson(json)).toList());
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to fetch accessories");
      }
    } catch (e) {
      debugPrint("Error fetching accessories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
  }
}

class UserAccessoriesScreen extends StatelessWidget {
  const UserAccessoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserAccessoriesController());

    final UserDashboardController navController = Get.find<UserDashboardController>();

    final favoritesController = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(

        toolbarHeight: 64.5.h,
        backgroundColor: AppColor.mainBc,
        elevation: 0,

        automaticallyImplyLeading: false,

        titleSpacing: 0,
        title: Text(
          "Accessories",
          style: GoogleFonts.manrope(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),

      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchAccessories(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 56.h,
                  width: 390.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E8EA),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: GoogleFonts.manrope(fontSize: 16.sp, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Search for accessories...",
                      hintStyle: GoogleFonts.manrope(
                        color: const Color(0xFF45464D),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF45464D)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() => Row(
                  children: [
                    CustomFilterButton(
                      text: "all",
                      isSelected: controller.selectedCategory.value == "all",
                      onTap: () => controller.updateCategory("all"),
                    ),
                    SizedBox(width: 8.w),
                    CustomFilterButton(
                      text: "Spare Parts",
                      isSelected: controller.selectedCategory.value == "Spare Parts",
                      onTap: () => controller.updateCategory("Spare Parts"),
                    ),
                    SizedBox(width: 8.w),
                    CustomFilterButton(
                      text: "Favourite",
                      isSelected: controller.selectedCategory.value == "Favourite",
                      onTap: () => controller.updateCategory("Favourite"),
                    ),
                    SizedBox(width: 8.w),
                    CustomFilterButton(
                      text: "ACCESSORY",
                      isSelected: controller.selectedCategory.value == "Accessories",
                      onTap: () => controller.updateCategory("Accessories"),
                    ),
                  ],
                )),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: AppColor.primary));
                  }

                  var filteredList = controller.accessories.where((item) {
                    bool matchesSearch = item.name.toLowerCase().contains(controller.searchQuery.value.toLowerCase());
                    if (!matchesSearch) return false;

                    if (item.stockQuantity <= 0) return false;

                    if (controller.selectedCategory.value == "all") return true;
                    if (controller.selectedCategory.value == "Favourite") {
                      return favoritesController.favoriteAccessories.any((fav) => fav.id == item.id);
                    }
                    return item.category.toLowerCase() == controller.selectedCategory.value.toLowerCase() ||
                        (controller.selectedCategory.value == "Spare Parts" && item.category.toLowerCase().contains("spare"));
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Text("No accessories found", style: GoogleFonts.manrope(fontSize: 16.sp)),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      mainAxisExtent: 315.h,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];

                      return AccessoryCard(
                        imageUrl: item.photoUrl ?? '',
                        title: item.name,
                        price: "\$${item.price.toStringAsFixed(2)}",
                        averageRating: item.averageRating, // تمرير التقييم هنا
                        isFavorite: favoritesController.isAccessoryFavorite(item),
                        onFavoriteTap: () => favoritesController.toggleAccessoryFavorite(item),
                        onViewDetails: () => Get.to(() => UserAccessoryDetails(accessory: item)),
                        onTap: () => Get.to(() => UserAccessoryDetails(accessory: item)),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () =>
            UserBottomNavBar(
              currentIndex: navController.currentIndex.value,
              onTap: navController.changeIndex,
            ),
      ),
    );
  }
}