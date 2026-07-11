import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:four_wheels/services/AuthService.dart';

class EmployeeNotificationService {
  static const String baseUrl =
      'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers {
    return {
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (AuthService.token != null)
        'Authorization': 'Bearer ${AuthService.token}',
    };
  }

  static String _notificationsUrl(String role) {
    if (role == 'driver') {
      return '$baseUrl/driver/notifications';
    }

    if (role == 'mechanic') {
      return '$baseUrl/mechanic/notifications';
    }

    return '$baseUrl/notifications/employees';
  }

  static String _markReadUrl(String role) {
    if (role == 'driver') {
      return '$baseUrl/driver/notifications/mark-read';
    }

    if (role == 'mechanic') {
      return '$baseUrl/mechanic/notifications/mark-read';
    }

    return '$baseUrl/notifications/employees/mark-read';
  }

  static Future<Map<String, dynamic>> getNotifications({
    required String role,
  }) async {
    try {
      final url = Uri.parse(_notificationsUrl(role));

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('EMP NOTIFICATIONS URL: $url');
      print('EMP NOTIFICATIONS STATUS: ${response.statusCode}');
      print('EMP NOTIFICATIONS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'data': data['data'] ?? data,
      };
    } catch (e) {
      print('EMP NOTIFICATIONS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> markRead({
    required String role,
  }) async {
    try {
      final url = Uri.parse(_markReadUrl(role));

      final response = await http.post(
        url,
        headers: _headers,
      );

      print('EMP MARK READ URL: $url');
      print('EMP MARK READ STATUS: ${response.statusCode}');
      print('EMP MARK READ BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 ||
            response.statusCode == 201 ||
            data['success'] == true ||
            data['status'] == 'success',
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('EMP MARK READ ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> clearNotifications({
    required String role,
  }) async {
    try {
      late final Uri url;
      late final http.Response response;

      if (role == 'driver') {
        url = Uri.parse('$baseUrl/driver/notifications');

        response = await http.delete(
          url,
          headers: _headers,
        );
      } else if (role == 'mechanic') {
        url = Uri.parse('$baseUrl/mechanic/notifications');

        response = await http.delete(
          url,
          headers: _headers,
        );
      } else {
        url = Uri.parse('$baseUrl/notifications/employees/clear-badges');

        response = await http.post(
          url,
          headers: _headers,
        );
      }

      print('EMP CLEAR NOTIFICATIONS URL: $url');
      print('EMP CLEAR NOTIFICATIONS STATUS: ${response.statusCode}');
      print('EMP CLEAR NOTIFICATIONS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204 ||
            data['success'] == true ||
            data['status'] == 'success',
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('EMP CLEAR NOTIFICATIONS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {
        'raw': decoded,
      };
    } catch (_) {
      return {
        'raw': body,
      };
    }
  }
}