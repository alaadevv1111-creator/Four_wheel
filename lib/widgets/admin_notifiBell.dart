import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/controller/admin_notifiController.dart';
import 'package:four_wheels/widgets/admin_notifiPop.dart';

class AdminNotificationBell extends StatefulWidget {
  final String initialType;
  final bool showFilters;

  const AdminNotificationBell({
    super.key,
    required this.initialType,
    required this.showFilters,
  });

  @override
  State<AdminNotificationBell> createState() => _AdminNotificationBellState();
}

class _AdminNotificationBellState extends State<AdminNotificationBell> {
  final AdminNotificationController notificationController =
  Get.isRegistered<AdminNotificationController>()
      ? Get.find<AdminNotificationController>()
      : Get.put(AdminNotificationController(), permanent: true);

  @override
  void initState() {
    super.initState();

    notificationController.fetchNotifications(
      type: widget.initialType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () {
              Get.dialog(
                AdminNotificationPopup(
                  initialType: widget.initialType,
                  showFilters: widget.showFilters,
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),

          if (notificationController.unreadCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  notificationController.unreadCount.toString(),
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 10,
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