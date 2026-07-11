import 'package:get/get.dart';

import 'package:four_wheels/models/admin_notifiModel.dart';
import 'package:four_wheels/services/admin_notifiService.dart';

class AdminNotificationController extends GetxController {
  final notifications = <AdminNotificationModel>[].obs;
  final selectedType = 'all'.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int get unreadCount {
    return notifications.where((item) => item.isRead == false).length;
  }

  Future<void> fetchNotifications({String type = 'all'}) async {
    selectedType.value = type;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await AdminNotificationService.getNotifications(type);

      if (result['success'] == true) {
        final body = result['data'];

        List list = [];

        if (body is List) {
          list = body;
        } else if (body is Map<String, dynamic>) {
          if (body['data'] is List) {
            list = body['data'];
          } else if (body['notifications'] is List) {
            list = body['notifications'];
          } else if (body['data'] is Map &&
              body['data']['notifications'] is List) {
            list = body['data']['notifications'];
          }
        }

        notifications.value = list
            .whereType<Map>()
            .map(
              (item) => AdminNotificationModel.fromJson(
            Map<String, dynamic>.from(item),
            defaultType: type,
          ),
        )
            .toList();
      } else {
        errorMessage.value =
            result['message'] ?? result['massage'] ?? 'Failed';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeType(String type) async {
    await fetchNotifications(type: type);
    await markRead(type);
  }

  Future<void> markRead(String type) async {
    await AdminNotificationService.markRead(type);
    await fetchNotifications(type: type);
  }

  Future<void> clearCurrentNotifications() async {
    final type = selectedType.value;

    final result = await AdminNotificationService.clearNotifications(type);

    if (result['success'] == true) {
      notifications.clear();
    }
  }
}