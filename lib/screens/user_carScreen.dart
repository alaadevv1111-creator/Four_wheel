import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/user_carcontroller.dart';
import 'package:four_wheels/models/user_cardetilesModel.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/utils/image_uelper.dart';
import 'package:four_wheels/constants/colors.dart';

class UserCarsScreen extends StatelessWidget {
  const UserCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserCarController controller =
    Get.isRegistered<UserCarController>()
        ? Get.find<UserCarController>()
        : Get.put(UserCarController());

    final UserDashboardController navController = Get.find<UserDashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Cars',
          style: GoogleFonts.manrope(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final selectedTab = controller.selectedTabIndex.value;
        final cars = controller.filteredCars;

        return RefreshIndicator(
          onRefresh: controller.loadCars,
          child: ListView(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 120.h),
            children: [
              Row(
                children: [
                  Expanded(
                    child: dateBox(
                      text: controller.displayStartDate,
                      onTap: () => controller.pickStartDate(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: dateBox(
                      text: controller.displayEndDate,
                      onTap: () => controller.pickEndDate(context),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              SizedBox(
                height: 42.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.tabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final selected =
                        controller.selectedTabIndex.value == index;

                    return GestureDetector(
                      onTap: () {
                        controller.changeTab(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xff101828)
                              : const Color(0xffF1F3F5),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Center(
                          child: Text(
                            controller.tabs[index],
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xff64748B),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 28.h),

              if (isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: const CircularProgressIndicator(),
                  ),
                )
              else
                if (cars.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 90.h),
                    child: Center(
                      child: Text(
                        'No cars found',
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ),
                  )
                else
                  ...cars.map(
                        (car) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: 22.h),
                          child: userCarCard(
                            car: car,
                            isFavorite: controller.favoriteCarIds.contains(
                              controller.readCarIdForUi(car),
                            ),
                            onTap: () => controller.openCarDetails(car),
                            onFavoriteTap: () => controller.toggleFavorite(car),
                          ),
                        ),
                  ),
            ],
          ),
        );
      }),

      bottomNavigationBar: Obx(
            () =>
            UserBottomNavBar(
              currentIndex: navController.currentIndex.value,
              onTap: navController.changeIndex,
            ),
      ),
    );
  }

  Widget dateBox({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xffEAECF0)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, size: 18.sp,
                color: const Color(0xff64748B)),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff101828),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget(String path) {
    final value = path.trim();

    if (value.isEmpty || value == 'null') {
      return _placeholder();
    }

    return Image.network(
      ImageHelper.resolveServerUrl(value),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xffE5E7EB),
      child: Center(
        child: Icon(
          Icons.directions_car,
          size: 46.sp,
          color: const Color(0xff94A3B8),
        ),
      ),
    );
  }

  String _readString(dynamic car, List<String> keys) {
    for (final key in keys) {
      try {
        dynamic value;

        switch (key) {
          case 'id':
            value = car.id;
            break;
          case 'image':
            value = car.image;
            break;
          case 'imageUrl':
            value = car.imageUrl;
            break;
          case 'name':
            value = car.name;
            break;
          case 'model':
            value = car.model;
            break;
          case 'brand':
            value = car.brand;
            break;
          case 'pricePerDay':
            value = car.pricePerDay;
            break;
          case 'price_per_day':
            value = car.pricePerDay;
            break;
          case 'rating':
            value = car.rating;
            break;
          case 'reviewsCount':
            value = car.reviewsCount;
            break;
          case 'rating_count':
            value = car.reviewsCount;
            break;
        }

        if (value != null && value
            .toString()
            .isNotEmpty) {
          return value.toString();
        }
      } catch (_) {}
    }

    return '';
  }

  Widget userCarCard({
    required CarDetailsModel car,
    required VoidCallback onTap,
    required VoidCallback onFavoriteTap,
    required bool isFavorite,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22.r),
                ),
                child: Image.network(
                  car.image,
                  height: 190.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(
                        height: 190.h,
                        color: const Color(0xffE5E7EB),
                        child: Icon(Icons.directions_car, size: 60.sp),
                      ),
                ),
              ),

              Positioned(
                top: 14.h,
                left: 14.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 13.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: car.isAvailable
                        ? const Color(0xffD1FADF)
                        : const Color(0xfff6ff50),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    car.isAvailable ? 'AVAILABLE TODAY' : 'RENTED',
                    style: GoogleFonts.manrope(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: car.isAvailable
                          ? const Color(0xff027A48)
                          : const Color(0xff131212),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xff101828),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        car.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff101828),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 9.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF7E6),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: const Color(0xffF59E0B),
                              size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            car.rating.toString(),
                            style: GoogleFonts.manrope(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                Text(
                  '${car.brand} • ${car.type}',
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff64748B),
                  ),
                ),

                SizedBox(height: 18.h),

                Row(
                  children: [
                    Text(
                      '\$${car.pricePerDay}',
                      style: GoogleFonts.manrope(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      ' /day',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff64748B),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget carTabs(UserCarController controller) {
    return Obx(
          () =>
          Row(
            children: List.generate(controller.tabs.length, (index) {
              final selected = controller.selectedTabIndex.value == index;

              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 22.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xff101828) : const Color(
                        0xffF1F3F5),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Text(
                    controller.tabs[index],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: selected ? Colors.white : const Color(0xff64748B),
                    ),
                  ),
                ),
              );
            }),
          ),
    );
  }
}