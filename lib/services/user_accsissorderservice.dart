import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AuthService.dart';
import '../models/user_accisorryorder.dart';

class UserAccessoryOrderService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers => {
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  static Future<Map<String, dynamic>> getOrdersByStatus(String status) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/accessories?status=$status');
      final response = await http.get(url, headers: _headers);

      print('USER ACCESSORY ORDERS STATUS: ${response.statusCode}');
      print('USER ACCESSORY ORDERS BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && (data['status'] == 'success' || data['success'] == true)) {
        final List list = data['data'] is List ? data['data'] : [];
        return {
          'success': true,
          'orders': list
              .whereType<Map<String, dynamic>>()
              .map((e) => UserAccessoryOrderModel.fromJson(e))
              .toList(),
        };
      }

      return {'success': false, 'message': data['message'] ?? 'Failed to load orders', 'orders': <UserAccessoryOrderModel>[]};
    } catch (e) {
      print('USER ACCESSORY ORDERS ERROR: $e');
      return {'success': false, 'message': 'connection error', 'orders': <UserAccessoryOrderModel>[]};
    }
  }

  static Future<Map<String, dynamic>> cancelOrder(String id) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/accessories/$id/cancel');
      final response = await http.post(url, headers: _headers);

      print('CANCEL USER ACCESSORY STATUS: ${response.statusCode}');
      print('CANCEL USER ACCESSORY BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message'] ?? '',
      };
    } catch (e) {
      print('CANCEL USER ACCESSORY ERROR: $e');
      return {'success': false, 'message': 'connection error'};
    }
  }
}