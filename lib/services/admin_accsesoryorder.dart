import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AuthService.dart';
import '../models/admin_accecoryorder.dart';

class AdminAccessoryOrderService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers => {
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  static Future<Map<String, dynamic>> getOrdersByStatus(String status) async {
    try {
      final url = Uri.parse('$baseUrl/admin/accessory-orders?status=$status');
      final response = await http.get(url, headers: _headers);

      print('ADMIN ACCESSORY ORDERS STATUS: ${response.statusCode}');
      print('ADMIN ACCESSORY ORDERS BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final List list = data['data'] is List ? data['data'] : [];
        return {
          'success': true,
          'orders': list
              .whereType<Map<String, dynamic>>()
              .map((e) => AdminAccessoryOrderModel.fromJson(e))
              .toList(),
        };
      }

      return {'success': false, 'message': data['message'] ?? 'Failed to load orders', 'orders': <AdminAccessoryOrderModel>[]};
    } catch (e) {
      print('ADMIN ACCESSORY ORDERS ERROR: $e');
      return {'success': false, 'message': 'connection error', 'orders': <AdminAccessoryOrderModel>[]};
    }
  }

  static Future<Map<String, dynamic>> getOrderDetails(String id) async {
    try {
      final url = Uri.parse('$baseUrl/admin/accessory-orders/$id');
      final response = await http.get(url, headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'success': true, 'order': AdminAccessoryOrderModel.fromJson(data['data'])};
      }

      return {'success': false, 'message': data['message'] ?? 'Failed to load order details'};
    } catch (e) {
      return {'success': false, 'message': 'connection error'};
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required String id,
    required String status, // 'active' | 'completed' | 'rejected'
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/accessory-orders/$id/status');
      final response = await http.patch(
        url,
        headers: {..._headers, 'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      print('UPDATE ACCESSORY ORDER STATUS: ${response.statusCode}');
      print('UPDATE ACCESSORY ORDER BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'success': true, 'message': data['message'] ?? 'Status updated'};
      }

      return {'success': false, 'message': data['message'] ?? 'Failed to update status'};
    } catch (e) {
      return {'success': false, 'message': 'connection error'};
    }
  }

  static Future<Map<String, dynamic>> deleteOrder(String id) async {
    try {
      final url = Uri.parse('$baseUrl/admin/accessory-orders/$id');
      final response = await http.delete(url, headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Order deleted'};
      }

      return {'success': false, 'message': data['message'] ?? 'Failed to delete order'};
    } catch (e) {
      return {'success': false, 'message': 'connection error'};
    }
  }
}