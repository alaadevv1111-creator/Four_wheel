class AdminNotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String createdAt;
  final bool isRead;

  AdminNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  factory AdminNotificationModel.fromJson(
      Map<String, dynamic> json, {
        String defaultType = 'all',
      }) {
    return AdminNotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ??
          json['data']?['title'] ??
          json['type'] ??
          'Notification',
      message: json['message'] ??
          json['body'] ??
          json['data']?['message'] ??
          json['data']?['body'] ??
          '',
      type: json['type']?.toString() ?? defaultType,
      createdAt: json['created_at']?.toString() ?? '',
      isRead: json['is_read'] == true ||
          json['read'] == true ||
          json['read_at'] != null,
    );
  }
}