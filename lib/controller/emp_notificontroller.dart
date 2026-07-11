import 'package:get/get.dart';

import 'package:four_wheels/models/admin_notifiModel.dart';
import 'package:four_wheels/services/emp_notifiservice.dart';

class EmployeeNotificationController extends GetxController {
  final String role;

  EmployeeNotificationController({
    required this.role,
  });

  final notifications = <AdminNotificationModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int get unreadCount {
    return notifications.where((item) => item.isRead == false).length;
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await EmployeeNotificationService.getNotifications(
        role: role,
      );

      if (result['success'] == true) {
        final raw = result['data'];

        List list = [];

        if (raw is List) {
          list = raw;
        } else if (raw is Map<String, dynamic>) {
          if (raw['data'] is List) {
            list = raw['data'];
          } else if (raw['notifications'] is List) {
            list = raw['notifications'];
          } else if (raw['data'] is Map &&
              raw['data']['notifications'] is List) {
            list = raw['data']['notifications'];
          }
        }

        notifications.assignAll(
          list
              .whereType<Map>()
              .map(
                (item) => AdminNotificationModel.fromJson(
              Map<String, dynamic>.from(item),
              defaultType: role,
            ),
          )
              .toList(),
        );
      } else {
        errorMessage.value =
            result['message']?.toString() ?? 'Failed to load notifications';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markRead() async {
    await EmployeeNotificationService.markRead(role: role);

    for (int i = 0; i < notifications.length; i++) {
      final item = notifications[i];

      notifications[i] = AdminNotificationModel(
        id: item.id,
        title: item.title,
        message: item.message,
        type: item.type,
        createdAt: item.createdAt,
        isRead: true,
      );
    }

    notifications.refresh();
  }

  Future<void> clearNotifications() async {
    final result = await EmployeeNotificationService.clearNotifications(
      role: role,
    );

    if (result['success'] == true) {
      notifications.clear();
    }
  }
}
