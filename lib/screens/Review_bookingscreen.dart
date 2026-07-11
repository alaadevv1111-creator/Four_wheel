import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/models/booking_review.dart';
import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/controller/review_bookingcontroller.dart';

import 'package:four_wheels/widgets/review_bookingdetils.dart';
import 'package:four_wheels/widgets/review_carcard.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';
import 'package:four_wheels/widgets/emp_avater.dart';

import 'package:four_wheels/widgets/no_lisencedailog.dart';
import 'package:four_wheels/widgets/Custom_toogle.dart';
import 'package:four_wheels/models/emp_model.dart';

class ReviewBookingScreen extends StatelessWidget {
  final BookingReviewModel review;

  ReviewBookingScreen({
    super.key,
    required this.review,
  });

  final UserDashboardController navController =
  Get.isRegistered<UserDashboardController>()
      ? Get.find<UserDashboardController>()
      : Get.put(UserDashboardController());

  @override
  Widget build(BuildContext context) {
    final ReviewBookingController controller = Get.put(
      ReviewBookingController(review: review),
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
            color: Color(0xff101828),
          ),
        ),
      ),
      body: Obx(
            () => ListView(
          padding: EdgeInsets.fromLTRB(28.w, 20.h, 28.w, 50.h),
          children: [
            Text(
              'Review Booking',
              style: GoogleFonts.manrope(
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              'Step 3 of 4: Finalize your selection',
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                color: const Color(0xff45464D),
              ),
            ),

            SizedBox(height: 32.h),

            ReviewCard(
              image: review.carImage,
              badge: 'Elite Class',
              name: review.carName,
              subtitle: '${review.carType} • ${review.carBrand}',
              pricePerDay: review.carPricePerDay,
            ),

            SizedBox(height: 32.h),

            Text(
              'Pickup Location',
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff64748B),
              ),
            ),

            SizedBox(height: 8.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xffEAECF0)),
              ),
              child: TextField(
                controller: controller.pickupLocationController,
                decoration: const InputDecoration(
                  hintText: 'Enter pickup location...',
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 18.h),

            ReviewBookingDetailCard(
              icon: Icons.keyboard_return_outlined,
              title: 'Return Details',
              location: review.returnLocation,
              dateTime: '${review.returnDate}, ${review.returnTime}',
            ),

            SizedBox(height: 36.h),

            Text(
              'Driving Option',
              style: GoogleFonts.manrope(
                fontSize: 21.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff191C1E),
              ),
            ),

            SizedBox(height: 16.h),

            _drivingInfoCard(controller),

            SizedBox(height: 36.h),

            Text(
              'Enhance Your Trip',
              style: GoogleFonts.manrope(
                fontSize: 21.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff191C1E),
              ),
            ),

            SizedBox(height: 16.h),

            _driverAddonTile(context, controller),

            if (controller.selectedDriver.value != null) ...[
              SizedBox(height: 12.h),
              _selectedDriverCard(context, controller),
            ],

            SizedBox(height: 12.h),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xffEAECF0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F4F7),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xff344054),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Insurance',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '\$25 / day',
                          style: GoogleFonts.manrope(
                            color: const Color(0xff667085),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomToggle(
                    value: controller.fullInsurance.value,
                    onChanged: controller.toggleInsurance,
                  ),
                ],
              ),
            ),
            SizedBox(height: 34.h),
            BookingPaymentSummaryCard(
              rentalText:
              'Rental (${controller.rentalDays} Days x \$${review.carPricePerDay})',
              rentalAmount: controller.money(controller.rentalTotal),
              additionalServices: controller.money(
                controller.insuranceTotal + controller.driverTotal,
              ),
              taxes: controller.money(controller.taxesAndFees),
              totalAmount: controller.money(controller.totalAmount),
              onConfirm: controller.confirmBooking,
            ),
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

  Widget _driverAddonTile(
      BuildContext context, ReviewBookingController controller) {
    final bool hasSelectedDriver = controller.selectedDriver.value != null;

    final bool toggleValue =
    hasSelectedDriver ? true : controller.professionalDriver.value;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xffEAECF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xffF2F4F7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Icon(
              Icons.person_pin_circle_outlined,
              color: Color(0xff344054),
              size: 20,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional Driver',
                  style: GoogleFonts.manrope(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff101828),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  controller.selectedDriver.value == null
                      ? '\$50 / day'
                      : controller.selectedDriver.value!.name,
                  style: GoogleFonts.manrope(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff667085),
                  ),
                ),
              ],
            ),
          ),
          CustomToggle(
            value: toggleValue,
            onChanged: hasSelectedDriver
                ? null
                : (value) {
              controller.toggleProfessionalDriver(value);

              if (value) {
                _openDriverDialog(context, controller);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openDriverDialog(
      BuildContext context,
      ReviewBookingController controller,
      ) async {
    EmployeeModel? tempSelected = controller.selectedDriver.value;

    final selectedDriver = await Get.dialog<EmployeeModel>(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Obx(
                () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Driver',
                  style: GoogleFonts.manrope(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),

                SizedBox(height: 18.h),

                if (controller.availableDrivers.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Text(
                      'No available drivers',
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff64748B),
                      ),
                    ),
                  )
                else
                  ...controller.availableDrivers.map((driver) {
                    final selected = tempSelected?.id == driver.id;

                    return StatefulBuilder(
                      builder: (context, setLocalState) {
                        return GestureDetector(
                          onTap: () {
                            setLocalState(() {
                              tempSelected = driver;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xffF8FAFC)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xff101828)
                                    : const Color(0xffE5E7EB),
                                width: selected ? 1.4 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                EmployeeAvatar(
                                  imagePath: _driverImage(driver),
                                  size: 54,
                                  isCircle: true,
                                ),

                                SizedBox(width: 12.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xff101828),
                                        ),
                                      ),

                                      SizedBox(height: 4.h),

                                      Text(
                                        '${_driverTrips(driver)} trips completed',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff64748B),
                                        ),
                                      ),

                                      SizedBox(height: 4.h),

                                      Row(
                                        children: [
                                          ...List.generate(5, (index) {
                                            return Icon(
                                              index < _driverRating(driver).round()
                                                  ? Icons.star_rounded
                                                  : Icons.star_border_rounded,
                                              size: 14.sp,
                                              color: const Color(0xffF59E0B),
                                            );
                                          }),
                                          SizedBox(width: 5.w),
                                          Text(
                                            _driverRating(driver).toStringAsFixed(1),
                                            style: GoogleFonts.manrope(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xff64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Radio<String>(
                                  value: driver.id,
                                  groupValue: tempSelected?.id,
                                  activeColor: const Color(0xff101828),
                                  onChanged: (_) {
                                    setLocalState(() {
                                      tempSelected = driver;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),

                SizedBox(height: 10.h),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(result: tempSelected);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff101828),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: const Text('Confirm'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (selectedDriver != null) {
      controller.selectDriver(selectedDriver);
      controller.toggleProfessionalDriver(true);
    } else {
      if (controller.selectedDriver.value == null) {
        controller.toggleProfessionalDriver(false);
      }
    }
  }

  void _openAddLicenseSheet(
      BuildContext context, ReviewBookingController controller) {
    Get.bottomSheet(
      Obx(
            () => Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Driving License',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff111827),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'License Number',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff111827),
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.licenseNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter 14-digit license number',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 14.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xff111827)),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'License Image',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff111827),
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: controller.pickLicenseImage,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffD9DEE3)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    controller.licenseFileName,
                    style: const TextStyle(color: Color(0xff101828)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () async {
                    await controller.addLicense();
                    if (controller.hasLicense.value) {
                      controller.toggleProfessionalDriver(true);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffF5B93D), Color(0xffE9A422)],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      controller.isLoading.value ? 'Saving...' : 'Save',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff111827),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _drivingInfoCard(ReviewBookingController controller) {
    final driver = controller.selectedDriver.value;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xffEAECF0)),
      ),
      child: Row(
        children: [
          Icon(
            driver != null
                ? Icons.person_pin_circle_outlined
                : controller.hasLicense.value
                ? Icons.badge_outlined
                : Icons.warning_amber_rounded,
            color: const Color(0xff344054),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              driver != null
                  ? 'Driver selected: ${driver.name}. Enable Professional Driver to add the fee.'
                  : controller.hasLicense.value
                  ? 'Driving license added'
                  : 'No driving license found',
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff101828),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedDriverCard(
      BuildContext context, ReviewBookingController controller) {
    final driver = controller.selectedDriver.value!;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          EmployeeAvatar(
            imagePath: _driverImage(driver),
            size: 48,
            isCircle: true,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Professional Driver',
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _openDriverDialog(context, controller);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  String _driverImage(dynamic driver) {
    try {
      final value = driver.imageUrl;
      if (value != null && value.toString().isNotEmpty) return value.toString();
    } catch (_) {}

    try {
      final value = driver.image;
      if (value != null && value.toString().isNotEmpty) return value.toString();
    } catch (_) {}

    return '';
  }
}
double _driverRating(dynamic driver) {
  try {
    return double.tryParse(driver.rating.toString()) ?? 0.0;
  } catch (_) {
    return 0.0;
  }
}

int _driverTrips(dynamic driver) {
  try {
    return int.tryParse(driver.tripsCompleted.toString()) ?? 0;
  } catch (_) {}

  try {
    return int.tryParse(driver.trips_completed.toString()) ?? 0;
  } catch (_) {}

  return 0;
}