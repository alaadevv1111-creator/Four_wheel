import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/controller/emp_dascontroller.dart';
import 'package:four_wheels/controller/driver_taskcontroller.dart';

class DriverOrderDetailsScreen extends StatefulWidget {
  final DriverBookingTaskModel task;
  final int initialTabIndex;

  const DriverOrderDetailsScreen({
    super.key,
    required this.task,
    required this.initialTabIndex,
  });

  @override
  State<DriverOrderDetailsScreen> createState() =>
      _DriverOrderDetailsScreenState();
}

class _DriverOrderDetailsScreenState extends State<DriverOrderDetailsScreen> {
  final EmployeeDashboardController profileController =
  Get.find<EmployeeDashboardController>();

  final DriverTasksController tasksController =
  Get.find<DriverTasksController>();

  late String taskStatus;
  DateTime? completedAt;

  @override
  void initState() {
    super.initState();

    if (widget.initialTabIndex == 0) {
      taskStatus = 'Pending';
    } else if (widget.initialTabIndex == 1) {
      taskStatus = 'In Progress';
    } else {
      taskStatus = 'Completed';
    }

    completedAt = widget.task.completedAt;
  }

  bool isActionLoading = false;

  bool get isCompleted {
    return taskStatus.toLowerCase().trim() == 'completed';
  }

  bool get ratingExpired {
    if (!isCompleted || completedAt == null) {
      return false;
    }

    return DateTime.now().difference(completedAt!) >
        const Duration(hours: 24);
  }

  Future<void> startTask() async {
    if (isActionLoading) return;

    setState(() {
      isActionLoading = true;
    });

    final success = await tasksController.startTrip(widget.task.id);

    if (success && mounted) {
      setState(() {
        taskStatus = 'In Progress';
      });
    }

    if (mounted) {
      setState(() {
        isActionLoading = false;
      });
    }
  }

  Future<void> completeTask() async {
    if (isActionLoading) return;

    setState(() {
      isActionLoading = true;
    });

    final success = await tasksController.completeTrip(widget.task.id);

    if (success && mounted) {
      setState(() {
        taskStatus = 'Completed';
        completedAt = DateTime.now();
      });

      Get.snackbar(
        'Task Completed',
        'You can rate this trip within 24 hours.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    if (mounted) {
      setState(() {
        isActionLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF1F3F6),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xff191C1E),
            size: 20.sp,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Text(
              'Order details',
              style: GoogleFonts.manrope(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff191C1E),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 100.h),
        child: Column(
          children: [
            _carHeaderCard(task),
            SizedBox(height: 14.h),
            _tripInfoCard(task),
          ],
        ),
      ),
      bottomNavigationBar: _bottomActions(),
    );
  }

  Widget _carHeaderCard(DriverBookingTaskModel task) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _carImage(task.carImage),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  bottom: 12.h,
                  right: 16.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.carName.isEmpty ? 'Vehicle' : task.carName,
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'VIN: ${task.vin.isEmpty ? '-' : task.vin}',
                        style: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.78),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: _customerRating(task.customerRating),
                ),
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: Color(0xffF2F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_car_filled_outlined,
                    color: const Color(0xff111827),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerRating(double? rating) {
    if (rating == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Rating',
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff191C1E),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Not rated yet',
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff94A3B8),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Rating',
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff191C1E),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < rating.round() ? Icons.star : Icons.star_border,
                color: const Color(0xffFBBF24),
                size: 15.sp,
              );
            }),
            SizedBox(width: 6.w),
            Text(
              rating.toStringAsFixed(1),
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff191C1E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tripInfoCard(DriverBookingTaskModel task) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _customerInfo(task),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PRICE',
                    style: GoogleFonts.manrope(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff4B5563),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _priceText(task.price),
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  title: 'Location',
                  value:
                  task.pickupLocation.isEmpty ? '-' : task.pickupLocation,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _smallInfo(
                  title: 'Trip Date',
                  value: task.bookingDate.isEmpty ? '-' : task.bookingDate,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(
            height: 1,
            color: Color(0xffE5E7EB),
          ),
          SizedBox(height: 14.h),
          GetBuilder<DriverTasksController>(
            builder: (tasksCtrl) {
              final rated = task.tripRating ?? tasksCtrl.ratedTrips[task.id];

              final canRate = isCompleted && rated == null && !ratingExpired;

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      ratingText(rated),
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff4B5563),
                      ),
                    ),
                  ),
                  _ratingStarsRow(task, rated, canRate),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _ratingStarsRow(DriverBookingTaskModel task, int? rated, bool canRate) {
    return Row(
      children: List.generate(5, (index) {
        final star = index + 1;
        final active = rated != null && star <= rated;

        final icon = Icon(
          Icons.star,
          color: active ? const Color(0xffFBBF24) : const Color(0xffCBD5E1),
          size: 20.sp,
        );

        if (!canRate) {
          return icon;
        }

        return GestureDetector(
          onTap: () async {
            await tasksController.rateTrip(task: task, rating: star);
            if (mounted) setState(() {});
          },
          child: icon,
        );
      }),
    );
  }

  Widget _customerInfo(DriverBookingTaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.customerName.isEmpty ? 'Customer' : task.customerName,
          style: GoogleFonts.manrope(
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff191C1E),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          task.customerPhone.isEmpty ? '-' : task.customerPhone,
          style: GoogleFonts.manrope(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff191C1E),
          ),
        ),
      ],
    );
  }

  Widget _smallInfo({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff64748B),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xff191C1E),
          ),
        ),
      ],
    );
  }

  Widget _bottomActions() {
    final status = taskStatus.toLowerCase().trim();

    final canStart =
        status == 'pending' || status == 'active' || status == 'current';

    final canComplete = status == 'in progress' || status == 'in_progress';

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44.h,
              child: ElevatedButton(
                onPressed: canStart && !isActionLoading ? startTask : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff25364D),
                  disabledBackgroundColor: const Color(0xffDDE2EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isActionLoading && canStart
                          ? 'Starting...'
                          : 'Start Task',
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 44.h,
              child: ElevatedButton(
                onPressed:
                canComplete && !isActionLoading ? completeTask : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff25364D),
                  disabledBackgroundColor: const Color(0xffE5E7EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  isActionLoading && canComplete
                      ? 'Completing...'
                      : 'Complete',
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color:
                    canComplete ? Colors.white : const Color(0xff94A3B8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _carPlaceholder();
        },
      );
    }

    if (imagePath.isNotEmpty) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _carPlaceholder();
        },
      );
    }

    return _carPlaceholder();
  }

  Widget _carPlaceholder() {
    return Container(
      color: const Color(0xffE5E7EB),
      child: Center(
        child: Icon(
          Icons.directions_car_filled_outlined,
          size: 48.sp,
          color: const Color(0xff94A3B8),
        ),
      ),
    );
  }

  Widget _circleEmployeeImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return CircleAvatar(
        radius: 14.r,
        backgroundImage: NetworkImage(imagePath),
      );
    }

    if (imagePath.isNotEmpty) {
      return CircleAvatar(
        radius: 14.r,
        backgroundImage: AssetImage(imagePath),
      );
    }

    return CircleAvatar(
      radius: 14.r,
      backgroundColor: const Color(0xffE5E7EB),
      child: Icon(
        Icons.person,
        color: const Color(0xff64748B),
        size: 14.sp,
      ),
    );
  }

  String _priceText(String price) {
    if (price.trim().isEmpty) return '\$0.00';
    if (price.trim().startsWith('\$')) return price;
    return '\$$price';
  }

  String ratingText(int? rated) {
    if (!isCompleted) {
      return 'Available after trip completion';
    }

    if (rated != null) {
      return 'Trip rating submitted';
    }

    if (ratingExpired) {
      return 'Rating period expired';
    }

    return 'Rate trip completion';
  }
}