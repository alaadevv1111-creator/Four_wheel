import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AuthService.dart';
import '../models/notifi_usermodel.dart';

class UserNotificationService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers => {
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  static Future<Map<String, dynamic>> getNotifications() async {
    try {
      final url = Uri.parse('$baseUrl/user/notifications');
      final response = await http.get(url, headers: _headers);

      print('USER NOTIFICATIONS STATUS: ${response.statusCode}');
      print('USER NOTIFICATIONS BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List list = data['data'] is List ? data['data'] : [];
        return {
          'success': true,
          'unreadCount': data['unread_count'] ?? 0,
          'notifications': list
              .whereType<Map<String, dynamic>>()
              .map((e) => UserNotificationModel.fromJson(e))
              .toList(),
        };
      }

      return {
        'success': false,
        'unreadCount': 0,
        'notifications': <UserNotificationModel>[],
      };
    } catch (e) {
      print('USER NOTIFICATIONS ERROR: $e');
      return {
        'success': false,
        'unreadCount': 0,
        'notifications': <UserNotificationModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      final url = Uri.parse('$baseUrl/user/notifications/mark-read');
      final response = await http.post(url, headers: _headers);

      print('MARK READ STATUS: ${response.statusCode}');
      print('MARK READ BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('MARK READ ERROR: $e');
      return {'success': false, 'message': 'connection error'};
    }
  }

  static Future<Map<String, dynamic>> deleteNotification(String id) async {
    try {
      final url = Uri.parse('$baseUrl/user/notifications/$id');
      final response = await http.delete(url, headers: _headers);

      print('DELETE NOTIFICATION STATUS: ${response.statusCode}');
      print('DELETE NOTIFICATION BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 && (data['success'] == true),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('DELETE NOTIFICATION ERROR: $e');
      return {'success': false, 'message': 'connection error'};
    }
  }
}