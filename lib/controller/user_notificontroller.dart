import 'package:get/get.dart';
import 'package:four_wheels/models/notifi_usermodel.dart';
import 'package:four_wheels/services/user_notifiservice.dart';

class UserNotificationController extends GetxController {
  final notifications = <UserNotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final result = await UserNotificationService.getNotifications();
      if (result['success'] == true) {
        notifications.assignAll(result['notifications']);
        unreadCount.value = int.tryParse(result['unreadCount'].toString()) ?? 0;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllAsRead() async {
    final result = await UserNotificationService.markAllAsRead();
    if (result['success'] == true) {
      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = UserNotificationModel(
          id: notifications[i].id,
          title: notifications[i].title,
          message: notifications[i].message,
          isRead: true,
          createdAt: notifications[i].createdAt,
          type: notifications[i].type,
        );
      }
      notifications.refresh();
      unreadCount.value = 0;
    }
  }

  Future<void> deleteNotification(String id) async {
    final result = await UserNotificationService.deleteNotification(id);
    if (result['success'] == true) {
      notifications.removeWhere((n) => n.id == id);
    }
  }
}