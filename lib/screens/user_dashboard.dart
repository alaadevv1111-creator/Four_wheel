import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../services/UserAccessoryService.dart';
import '../widgets/custom_service_card.dart';
import '../widgets/car_rental_card.dart';
import '../widgets/car_horizontal_card.dart';
import '../widgets/accessory_card.dart';
import '../widgets/profileavator.dart';
import '../widgets/special_offer_card.dart';
import '../widgets/custom_button2.dart';
import '../models/accessory_model.dart';
import 'user_Accessories.dart';
import 'user_accessory_details.dart';
import 'favorites_screen.dart';
import 'user_profile_screen.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';
import 'package:four_wheels/screens/user_carScreen.dart';
import 'package:four_wheels/screens/request_mechanicScreen.dart';
import 'package:four_wheels/controller/user_carcontroller.dart';
import 'package:four_wheels/services/carService.dart'; // عدّلي المسار حسب مكان الملف الفعلي
import 'package:four_wheels/models/car_model.dart';
import 'package:four_wheels/controller/car_controller.dart';

import 'package:four_wheels/models/user_cardetilesModel.dart';
class UserDashboardController2 extends GetxController {
  final String promoImage = "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=2070&auto=format&fit=crop";

  final RxList<Map<String, dynamic>> recommendedCars = <Map<String, dynamic>>[
    {
      "imageUrl": "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?q=80&w=2070&auto=format&fit=crop",
      "name": "Porsche Taycan",
      "price": r"$200 / day",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1506015391300-4802dc74de2e?q=80&w=2070&auto=format&fit=crop",
      "name": "Range Rover Vogue",
      "price": r"$100 / day",
    }
  ].obs;

  final RxList<AccessoryModel> featuredAccessories = <AccessoryModel>[].obs;
  var isLoadingAccessories = true.obs;


  @override
  void onInit() {
    super.onInit();
    fetchRandomAccessories();

  }

  Future<void> fetchRandomAccessories() async {
    try {
      isLoadingAccessories.value = true;
      final response = await UserAccessoryService.getAllAccessories();
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        List<AccessoryModel> availableItems = data
            .map((json) => AccessoryModel.fromJson(json))
            .where((item) => item.stockQuantity > 0)
            .toList();

        if (availableItems.isNotEmpty) {
          availableItems.shuffle();
          featuredAccessories.assignAll(availableItems.take(2).toList());
        } else {
          featuredAccessories.clear();
        }
      }
    } catch (e) {
      debugPrint("Dashboard Accessories Error: \$e");
    } finally {
      isLoadingAccessories.value = false;
    }
  }
}

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final UserDashboardController navController =
    Get.isRegistered<UserDashboardController>()
        ? Get.find<UserDashboardController>()
        : Get.put(UserDashboardController(), permanent: true);
    // نستخدم Get.put ليكون الكنترولر متاحاً في الذاكرة ومحدثاً دائماً
    final FavoritesController favoritesController = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController(), permanent: true);

    final controller = Get.put(UserDashboardController2());

    final userProfileController = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());

    final CarController carController = Get.isRegistered<CarController>()
        ? Get.find<CarController>()
        : Get.put(CarController());

    final UserCarController userCarController = Get.isRegistered<UserCarController>()
        ? Get.find<UserCarController>()
        : Get.put(UserCarController());

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        toolbarHeight: 64.5.h,
        backgroundColor: AppColor.mainBc,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16.w,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.to(() => const UserProfileScreen()),
              child: Profileavator(radius: 22.r, fontSize: 14.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "WELCOME BACK,",
                    style: GoogleFonts.manrope(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF515F74),
                      letterSpacing: 0.55,
                    ),
                  ),
                  Obx(() => Text(
                    userProfileController.fullName.value,
                    style: GoogleFonts.manrope(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF131B2E),
                      letterSpacing: -0.45,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),

      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchRandomAccessories();
          await favoritesController.fetchFavorites();
          await userCarController.loadCars();
          await carController.loadCars(); // جديد
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromoBanner(controller),
              SizedBox(height: 32.h),
              _buildServiceGrid(),
              SizedBox(height: 40.h),
              _buildSectionHeader("Featured in Cairo", "View All Cars"),
              SizedBox(height: 16.h),
              Obx(() {
                if (userCarController.isLoading.value && userCarController.cars.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColor.primary));
                }

                final featured = userCarController.cars.take(3).toList();

                if (featured.isEmpty) {
                  return Center(
                    child: Text("No cars available", style: GoogleFonts.manrope(color: Colors.grey, fontSize: 14.sp)),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featured.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final car = featured[index];
                    return Obx(() => CarRentalCard(
                      imageUrl: car.image,
                      carName: car.name,
                      price: car.pricePerDay,
                      rating: car.rating?.toStringAsFixed(1) ?? 'New',
                      reviewsCount: car.reviewsCount?.toString() ?? '0',
                      isAvailable: car.isAvailable,
                      isFavorite: favoritesController.isCarFavorite(car),
                      onFavoriteTap: () => favoritesController.toggleCarFavorite(car),
                      onViewDetails: () => Get.to(() => UserCarsScreen()), // بدل openCarDetails المباشر
                    ));
                  },
                );
              }),
              SizedBox(height: 24.h),
              SpecialOfferCard(
                imageUrl: "https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?q=80&w=2067&auto=format&fit=crop",
                onTap: () {},
              ),
              SizedBox(height: 32.h),
              Text(
                "Recommended for You",
                style: GoogleFonts.manrope(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                if (userCarController.isLoading.value && userCarController.cars.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColor.primary));
                }

                final recommended = userCarController.cars.length > 3
                    ? userCarController.cars.sublist(3)
                    : <CarDetailsModel>[];

                if (recommended.isEmpty) {
                  return Center(
                    child: Text("No more cars to recommend", style: GoogleFonts.manrope(color: Colors.grey, fontSize: 14.sp)),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommended.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final car = recommended[index];
                    return CarHorizontalCard(
                      imageUrl: car.image,
                      carName: car.name,
                      subtitle: "\$${car.pricePerDay} / day",
                      onTap: () => Get.to(() => UserCarsScreen()),
                    );
                  },
                );
              }),
              SizedBox(height: 32.h),
              _buildSectionHeader(
                "Featured Accessories",
                "View All",
                onTap: () => Get.to(() => const UserAccessoriesScreen()),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                if (controller.isLoadingAccessories.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColor.primary));
                }
                if (controller.featuredAccessories.isEmpty) {
                  return Center(
                    child: Text("No accessories found", style: GoogleFonts.manrope(color: Colors.grey, fontSize: 14.sp)),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.featuredAccessories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    mainAxisExtent: 355.h,
                  ),
                  itemBuilder: (context, index) {
                    final acc = controller.featuredAccessories[index];
                    // تم تغليف الكارت بـ Obx لضمان تحديث حالة القلب فوراً
                    return Obx(() => AccessoryCard(
                      imageUrl: acc.photoUrl ?? '',
                      title: acc.name,
                      price: "\\\$${acc.price.toStringAsFixed(2)}",
                      averageRating: acc.averageRating,
                      isFavorite: favoritesController.isAccessoryFavorite(acc),
                      onFavoriteTap: () => favoritesController.toggleAccessoryFavorite(acc),
                      onTap: () => Get.to(() => UserAccessoryDetails(accessory: acc)),
                      onViewDetails: () => Get.to(() => UserAccessoryDetails(accessory: acc)),
                    ));
                  },
                );
              }),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Obx(
            () => UserBottomNavBar(
              currentIndex: navController.currentIndex.value,
              onTap: navController.changeIndex,
            ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), letterSpacing: -0.5)),
        GestureDetector(
          onTap: onTap,
          child: Text(actionText, style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        ),
      ],
    );
  }

  Widget _buildServiceGrid() {
    return Column(
      children: [
        CustomServiceCard(icon: Icons.directions_car_filled_rounded, title: "Rent a Car", subtitle: "Premium fleet at your service.", backgroundGraphic: Icon(Icons.vpn_key_rounded, size: 130.r, color: Colors.black), onTap: () => Get.to(() => UserCarsScreen())),
        SizedBox(height: 16.h),
        CustomServiceCard(icon: Icons.build_circle_rounded, title: "Request Mechanic", subtitle: "Expert care for your wheels.", backgroundGraphic: Icon(Icons.build_rounded, size: 130.r, color: Colors.black), onTap: () => Get.to(() => RequestMechanicScreen())),
        SizedBox(height: 16.h),
        CustomServiceCard(icon: Icons.shopping_bag_outlined, title: "Accessories Store", subtitle: "Upgrade your driving experience.", backgroundGraphic: Icon(Icons.settings_input_component_rounded, size: 130.r, color: Colors.black), onTap: () => Get.to(() => const UserAccessoriesScreen())),
      ],
    );
  }

  Widget _buildPromoBanner(UserDashboardController2 controller) {
    return Container(
      width: 358.w,
      height: 256.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 8))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            Image.network(controller.promoImage, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.85), Colors.black.withOpacity(0.1)]))),
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text("The First\nOrder is\n20% off", style: GoogleFonts.manrope(color: Colors.white, fontSize: 34.sp, fontWeight: FontWeight.w900, height: 1.1)))),
                  SizedBox(height: 20.h),
                  CustomButton(text: "Order now", width: 180.w, height: 48.h, backgroundColor: AppColor.cardBg, textColor: Colors.black, borderRadius: 10, onTap: () => Get.to(() => const UserAccessoriesScreen())),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
