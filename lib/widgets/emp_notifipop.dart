import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/emp_notificontroller.dart';

class EmployeeNotificationPopup extends StatefulWidget {
  final String role;

  const EmployeeNotificationPopup({
    super.key,
    required this.role,
  });

  @override
  State<EmployeeNotificationPopup> createState() =>
      _EmployeeNotificationPopupState();
}

class _EmployeeNotificationPopupState extends State<EmployeeNotificationPopup> {
  late final EmployeeNotificationController controller;

  @override
  void initState() {
    super.initState();

    final tag = 'notifications_${widget.role}';

    controller = Get.find<EmployeeNotificationController>(tag: tag);

    controller.fetchNotifications().then((_) {
      controller.markRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.only(
        top: 90.h,
        right: 20.w,
        left: 20.w,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: 430.h,
          maxWidth: 390.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 35.r,
              offset: Offset(0, 18.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 14.w, 10.h),
              child: Row(
                children: [
                  Text(
                    'Notifications',
                    style: GoogleFonts.manrope(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff111827),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: controller.clearNotifications,
                    child: Text(
                      'Clear',
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      'No new notifications',
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final item = controller.notifications[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: item.isRead
                            ? Colors.white
                            : const Color(0xffEEF6FF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xffE5E7EB),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _typeIcon(widget.role),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff111827),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  item.message,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff45464D),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  item.createdAt,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeIcon(String role) {
    IconData icon;

    if (role == 'driver') {
      icon = Icons.directions_car;
    } else if (role == 'mechanic') {
      icon = Icons.handyman_outlined;
    } else {
      icon = Icons.person;
    }

    return CircleAvatar(
      radius: 18.r,
      backgroundColor: const Color(0xffF1F5F9),
      child: Icon(
        icon,
        size: 18.sp,
        color: const Color(0xff1F2A44),
      ),
    );
  }
}