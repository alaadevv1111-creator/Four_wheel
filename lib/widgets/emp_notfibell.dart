import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/emp_notificontroller.dart';
import 'package:four_wheels/widgets/emp_notifipop.dart';

class EmployeeNotificationBell extends StatefulWidget {
  final String role;

  const EmployeeNotificationBell({
    super.key,
    required this.role,
  });

  @override
  State<EmployeeNotificationBell> createState() =>
      _EmployeeNotificationBellState();
}

class _EmployeeNotificationBellState extends State<EmployeeNotificationBell> {
  late final EmployeeNotificationController controller;

  @override
  void initState() {
    super.initState();

    final tag = 'notifications_${widget.role}';

    controller = Get.isRegistered<EmployeeNotificationController>(tag: tag)
        ? Get.find<EmployeeNotificationController>(tag: tag)
        : Get.put(
      EmployeeNotificationController(role: widget.role),
      tag: tag,
      permanent: true,
    );

    controller.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () {
              controller.fetchNotifications();

              Get.dialog(
                EmployeeNotificationPopup(
                  role: widget.role,
                ),
              );
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              size: 24.sp,
              color: const Color(0xff191C1E),
            ),
          ),

          if (controller.unreadCount > 0)
            Positioned(
              right: 8.w,
              top: 8.h,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  controller.unreadCount.toString(),
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}