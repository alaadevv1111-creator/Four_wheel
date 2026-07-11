import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/user_cardetilcontroller.dart';
import 'package:four_wheels/models/user_cardetilesModel.dart';
import 'package:four_wheels/widgets/user_carvichel.dart';
import 'package:four_wheels/widgets/user_carAdditionl.dart';
import 'package:four_wheels/widgets/user_carbottombookingbar.dart';
import 'package:four_wheels/widgets/user_carimage_slider.dart';
import 'package:four_wheels/widgets/user_cartitle&price.dart';
import 'package:four_wheels/widgets/user_catrentelrequrment.dart';
import 'package:four_wheels/widgets/user_carrentlsumm.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';
import 'package:google_fonts/google_fonts.dart';

class CarDetailsBookingScreen extends StatelessWidget {
  final CarDetailsModel car;
  final String selectedStartDate;
  final String selectedEndDate;

  CarDetailsBookingScreen({
    super.key,
    required this.car,
    required this.selectedStartDate,
    required this.selectedEndDate,
  });

  final UserDashboardController navController =
  Get.isRegistered<UserDashboardController>()
      ? Get.find<UserDashboardController>()
      : Get.put(UserDashboardController());

  @override
  Widget build(BuildContext context) {
    final CarDetailsBookingController controller = Get.put(
      CarDetailsBookingController(
        car: car,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Obx(
                () => IconButton(
              onPressed: () {
                controller.toggleFavorite();
              },
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarDetailsImageSlider(
              images: car.images.isEmpty ? [car.image] : car.images,
              currentIndex: controller.currentImageIndex,
              onPageChanged: controller.changeImageIndex,
            ),

            CarDetailsTitleSection(
              name: car.name,
              pricePerDay: car.pricePerDay,
              isAvailable: car.isAvailable,
              availabilityText: car.availabilityText,
              rating: car.rating,
              reviewsCount: car.reviewsCount,
            ),

            CarAboutSection(
              description: car.description,
              isExpanded: controller.isDescriptionExpanded,
              onToggle: controller.toggleDescription,
            ),

            RentalSummaryCard(
              pickupDate: selectedStartDate,
              pickupTime: '',
              returnDate: selectedEndDate,
              returnTime: '',
              rentalDays: controller.rentalDays,
              estimatedTotal: controller.estimatedTotal,
            ),
            SizedBox(height: 34.h),
            _additionalInfoSection(),

            RentalRequirementsCard(
              requirements: car.requirements,
            ),

            SizedBox(height: 34.h),

            CarBookingBottomBar(
              totalPrice: controller.estimatedTotal,
              isBooking: controller.isBooking,
              onBookNow: controller.openLicenseQuestion,
            ),

            SizedBox(height: 24.h),
          ],
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
}

Widget _additionalInfoSection() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 28.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff191C1E),
          ),
        ),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _infoChip(Icons.location_on_outlined, 'Pickup Location'),
            _infoChip(Icons.verified_user_outlined, 'Insurance Incl.'),
            _infoChip(Icons.gps_fixed_outlined, 'GPS Available'),
            _infoChip(Icons.bluetooth, 'Bluetooth'),
          ],
        ),
      ],
    ),
  );
}

Widget _infoChip(IconData icon, String title) {
  return Container(
    width: 160.w,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
    decoration: BoxDecoration(
      color: const Color(0xffF1F3F5),
      borderRadius: BorderRadius.circular(14.r),
    ),
    child: Row(
      children: [
        Icon(icon, size: 17.sp, color: const Color(0xff101828)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff101828),
            ),
          ),
        ),
      ],
    ),
  );
}