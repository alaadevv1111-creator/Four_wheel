class UserNotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;
  final String type;

  UserNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.type,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
    return UserNotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ??
          json['notification_title']?.toString() ??
          'Notification',
      message: json['message']?.toString() ??
          json['body']?.toString() ??
          json['description']?.toString() ??
          '',
      isRead: json['is_read'] == true ||
          json['is_read']?.toString() == '1' ||
          json['read'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}