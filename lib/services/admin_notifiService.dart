import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:four_wheels/services/AuthService.dart';

class AdminNotificationService {
  static const String baseUrl =
      'https://reload-hug-monastery.ngrok-free.dev/api/v1';


  static String getUrlByType(String type) {
    switch (type) {
      case 'cars':
        return '$baseUrl/notifications/cars';

      case 'employees':
        return '$baseUrl/notifications/employees';

      case 'orders':
        return '$baseUrl/admin/orders/notifications';

      case 'parts':
        return '$baseUrl/notifications/parts';

      case 'all':
      default:
        return '$baseUrl/dashboard/notifications';
    }
  }
  static String markReadUrlByType(String type) {
    switch (type) {
      case 'cars':
        return '$baseUrl/notifications/cars/mark-read';

      case 'employees':
        return '$baseUrl/notifications/employees/mark-read';

      case 'orders':
        return '$baseUrl/admin/orders/notifications/mark-read';

      case 'parts':
        return '$baseUrl/notifications/parts/mark-read';

      case 'all':
      default:
        return '$baseUrl/dashboard/notifications/mark-all-read';
    }
  }

  static String clearUrlByType(String type) {
    switch (type) {
      case 'cars':
        return '$baseUrl/notifications/cars/clear-badges';

      case 'employees':
        return '$baseUrl/notifications/employees/clear-badges';

      case 'orders':
        return '$baseUrl/admin/orders/notifications';

      case 'parts':
        return '$baseUrl/notifications/parts/clear-badges';

      case 'all':
      default:
        return '$baseUrl/dashboard/notifications/clear-all';
    }
  }

  static Future<Map<String, dynamic>> getNotifications(String type) async {
    try {
      final url = Uri.parse(getUrlByType(type));

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      print('NOTIFICATIONS $type STATUS: ${response.statusCode}');
      print('NOTIFICATIONS $type BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to load notifications',
        'data': data,
      };
    } catch (e) {
      print('NOTIFICATIONS ERROR: $e');

      return {
        'success': false,
        'massage': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> markRead(String type) async {
    try {
      final url = Uri.parse(markReadUrlByType(type));

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      final data = _decode(response.body);

      print('MARK READ $type STATUS: ${response.statusCode}');
      print('MARK READ $type BODY: ${response.body}');

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'massage': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> clearNotifications(String type) async {
    try {
      final url = Uri.parse(clearUrlByType(type));

      final response = type == 'orders'
          ? await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      )
          : await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'massage': 'connection error',
        'data': null,
      };
    }
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'raw': decoded};
    } catch (_) {
      return {'raw': body};
    }
  }
}