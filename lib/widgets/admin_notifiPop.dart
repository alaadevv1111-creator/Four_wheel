import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/controller/admin_notifiController.dart';

class AdminNotificationPopup extends StatefulWidget {
  final String initialType;
  final bool showFilters;

  const AdminNotificationPopup({
    super.key,
    this.initialType = 'all',
    this.showFilters = true,
  });

  @override
  State<AdminNotificationPopup> createState() => _AdminNotificationPopupState();
}

class _AdminNotificationPopupState extends State<AdminNotificationPopup> {
  final AdminNotificationController controller =
  Get.find<AdminNotificationController>();

  @override
  void initState() {
    super.initState();

    controller.fetchNotifications(type: widget.initialType).then((_) {
      controller.markRead(widget.initialType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 90, right: 24, left: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 390,
        constraints: const BoxConstraints(maxHeight: 430),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 10),
              child: Row(
                children: [
                  Text(
                    'Notification Center',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff111827),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: controller.clearCurrentNotifications,
                    child: Text(
                      'Clear Notifications',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (widget.showFilters) _filters(),

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
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final item = controller.notifications[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.isRead
                            ? Colors.white
                            : const Color(0xffEEF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffE5E7EB),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _typeIcon(item.type),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff111827),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.message,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff45464D),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.createdAt,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
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

  Widget _filters() {
    final filters = [
      {
        'type': 'all',
        'label': 'All',
        'icon': Icons.all_inbox,
      },
      {
        'type': 'employees',
        'label': 'Employees',
        'icon': Icons.person,
      },
      {
        'type': 'cars',
        'label': 'Cars',
        'icon': Icons.directions_car,
      },
      {
        'type': 'orders',
        'label': 'Orders',
        'icon': Icons.calendar_month,
      },
      {
        'type': 'parts',
        'label': 'Parts',
        'icon': Icons.build,
      },
    ];

    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: filters.map((filter) {
          final selected = controller.selectedType.value == filter['type'];

          return GestureDetector(
            onTap: () {
              controller.changeType(filter['type'] as String);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 18,
                    color: selected ? Colors.black : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    filter['label'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: selected ? Colors.black : Colors.grey,
                      fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _typeIcon(String type) {
    IconData icon;

    switch (type) {
      case 'cars':
        icon = Icons.directions_car;
        break;
      case 'employees':
        icon = Icons.person;
        break;
      case 'orders':
        icon = Icons.calendar_month;
        break;
      case 'parts':
        icon = Icons.build;
        break;
      default:
        icon = Icons.notifications_none;
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xffF1F5F9),
      child: Icon(
        icon,
        size: 18,
        color: const Color(0xff1F2A44),
      ),
    );
  }
}