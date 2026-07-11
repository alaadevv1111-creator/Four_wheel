import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/mechanic_jobcontroller.dart';
import 'package:four_wheels/models/mechanic_jobmodel.dart';
import 'package:four_wheels/utils/image_uelper.dart';
import 'package:four_wheels/controller/emp_dascontroller.dart';

class MechanicJobDetailsScreen extends StatefulWidget {
  final MechanicJobModel job;

  const MechanicJobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  State<MechanicJobDetailsScreen> createState() =>
      _MechanicJobDetailsScreenState();
}

class _MechanicJobDetailsScreenState extends State<MechanicJobDetailsScreen> {
  final EmployeeDashboardController profileController =
  Get.isRegistered<EmployeeDashboardController>()
      ? Get.find<EmployeeDashboardController>()
      : Get.put(EmployeeDashboardController());

  final MechanicJobsController controller =
  Get.find<MechanicJobsController>();

  late MechanicJobModel job;
  bool isLoading = false;
  bool isActionLoading = false;

  int selectedRating = 0;
  int? savedCustomerRating;
  bool isRatingSubmitting = false;

  @override
  void initState() {
    super.initState();
    job = widget.job;
    savedCustomerRating = job.customerRating;
    selectedRating = savedCustomerRating ?? 0;
    _loadDetails();
    profileController.loadEmployeeProfile();
  }

  bool get alreadyRated {
    return savedCustomerRating != null;
  }

  bool get canRateCustomer {
    return job.isCompleted && !alreadyRated;
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
    });

    final details = await controller.getJobDetails(job.id);

    if (details != null && mounted) {
      setState(() {
        job = details;
        savedCustomerRating = job.customerRating;
        selectedRating = savedCustomerRating ?? 0;
      });
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _startRepair() async {
    setState(() {
      isActionLoading = true;
    });

    final success = await controller.startJob(job.id);

    if (success && mounted) {
      setState(() {
        job = job.copyWith(status: 'in_progress');
      });
    }

    if (mounted) {
      setState(() {
        isActionLoading = false;
      });
    }
  }

  Future<void> _completeJob() async {
    setState(() {
      isActionLoading = true;
    });

    final success = await controller.completeJob(job.id);

    if (success && mounted) {
      setState(() {
        job = job.copyWith(status: 'completed');
      });
    }

    if (mounted) {
      setState(() {
        isActionLoading = false;
      });
    }
  }

  Future<void> selectCustomerRating(int rating) async {
    if (!canRateCustomer || isRatingSubmitting) return;

    setState(() {
      selectedRating = rating;
      isRatingSubmitting = true;
    });

    final success = await controller.rateCustomer(
      jobId: job.id,
      rating: rating,
    );

    if (success && mounted) {
      setState(() {
        savedCustomerRating = rating;
      });
    }

    if (mounted) {
      setState(() {
        isRatingSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff101828),
          ),
        ),
        title: Text(
          'Repair Order Details',
          style: GoogleFonts.manrope(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 130.h),
        children: [
          _serviceTypeCard(),
          SizedBox(height: 18.h),
          _reportedIssueCard(),
          SizedBox(height: 18.h),
          _scheduleLocationCard(),
          SizedBox(height: 18.h),
          _customerDetailsCard(),
        ],
      ),
      bottomNavigationBar: _bottomActions(),
    );
  }

  Widget _serviceTypeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: const Color(0xffF1F5F9),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.build_outlined,
              color: const Color(0xff334155),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SERVICE TYPE',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5.sp,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff94A3B8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  job.serviceType,
                  style: GoogleFonts.manrope(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff101828),
                  ),
                ),
              ],
            ),
          ),
          _statusPill(job),
        ],
      ),
    );
  }

  Widget _reportedIssueCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFEF2F2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xffEF4444),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Reported Issue',
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Text(
            job.vehicleModel,
            style: GoogleFonts.manrope(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xff334155),
            ),
          ),

          SizedBox(height: 12.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xffF1F5F9),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              job.problemDescription.isEmpty
                  ? 'No issue description provided.'
                  : job.problemDescription,
              style: GoogleFonts.manrope(
                fontSize: 13.5.sp,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xff64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleLocationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule & Location',
            style: GoogleFonts.manrope(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff101828),
            ),
          ),
          SizedBox(height: 16.h),
          _scheduleRow(
            icon: Icons.calendar_month_outlined,
            title: 'DATE & TIME',
            value: '${job.date} • ${job.time}',
          ),
          SizedBox(height: 16.h),
          _scheduleRow(
            icon: Icons.location_on_outlined,
            title: 'LOCATION',
            value: job.location.isEmpty ? '-' : job.location,
          ),
        ],
      ),
    );
  }

  Widget _scheduleRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: const Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 17.sp, color: const Color(0xff64748B)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10.sp,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff94A3B8),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff334155),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customerDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: GoogleFonts.manrope(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff101828),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _customerAvatar(job.customerImage, job.customerName),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.customerName.isEmpty ? 'Customer' : job.customerName,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff101828),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      job.customerPhone.isEmpty
                          ? 'No phone number'
                          : job.customerPhone,
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff64748B),
                      ),
                    ),
                  ],
                ),
              ),
              _roundIcon(Icons.call_outlined),
            ],
          ),
          if (job.isCompleted) ...[
            SizedBox(height: 18.h),
            _ratingCard(),
          ],
        ],
      ),
    );
  }

  Widget _bottomActions() {
    if (job.isCompleted) {
      return const SizedBox.shrink();
    }

    final bool showStart = job.isPending;
    final bool showComplete = job.isInProgress;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 28.h),
      color: const Color(0xffF8FAFC),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: GestureDetector(
          onTap: isActionLoading
              ? null
              : (showStart
              ? _startRepair
              : showComplete
              ? _completeJob
              : null),
          child: Container(
            decoration: BoxDecoration(
              color: showComplete
                  ? const Color(0xff12B76A)
                  : const Color(0xff25364D),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    showComplete
                        ? Icons.check_circle_outline
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    isActionLoading
                        ? 'Please wait...'
                        : (showComplete ? 'Complete Order' : 'Start Repair'),
                    style: GoogleFonts.manrope(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customerAvatar(String image, String name) {
    final path = image.trim();

    if (path.isEmpty || ImageHelper.isEmpty(path)) {
      final initials = _initialsOf(name);
      return CircleAvatar(
        radius: 24.r,
        backgroundColor: const Color(0xffE5E7EB),
        child: Text(
          initials,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff475467),
          ),
        ),
      );
    }

    if (ImageHelper.isLocalFile(path)) {
      return CircleAvatar(
        radius: 24.r,
        backgroundImage: FileImage(File(path)),
      );
    }

    return CircleAvatar(
      radius: 24.r,
      backgroundImage: NetworkImage(
        ImageHelper.resolveServerUrl(path),
      ),
    );
  }

  String _initialsOf(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  Widget _roundIcon(IconData icon) {
    return Container(
      width: 42.w,
      height: 42.h,
      decoration: const BoxDecoration(
        color: Color(0xffF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20.sp,
        color: const Color(0xff101828),
      ),
    );
  }

  Widget _ratingCard() {
    return Obx(() {
      final rated = controller.ratedCustomerJobs[job.id] ?? job.customerRating;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate the Customer',
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),

            SizedBox(height: 18.h),

            Row(
              children: List.generate(5, (index) {
                final value = index + 1;
                final active = rated != null && value <= rated;

                final icon = Icon(
                  active ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 34.sp,
                  color: active
                      ? const Color(0xffF59E0B)
                      : const Color(0xffCBD5E1),
                );

                if (rated != null) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: icon,
                  );
                }

                return GestureDetector(
                  onTap: () {
                    controller.rateCustomer(jobId: job.id, rating: value);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: icon,
                  ),
                );
              }),
            ),

            SizedBox(height: 14.h),

            Text(
              rated != null
                  ? 'You rated this customer $rated/5'
                  : 'Tap a star to rate',
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff64748B),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _statusPill(MechanicJobModel job) {
    Color bg;
    Color fg;
    String text;

    if (job.isCompleted) {
      bg = const Color(0xffECFDF3);
      fg = const Color(0xff12B76A);
      text = 'DONE';
    } else if (job.isInProgress) {
      bg = const Color(0xffEEF4FF);
      fg = const Color(0xff3B5BDB);
      text = 'IN PROGRESS';
    } else {
      bg = const Color(0xffFFFBEB);
      fg = const Color(0xffB45309);
      text = 'ACTIVE';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: fg,
        ),
      ),
    );
  }
}