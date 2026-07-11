import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AuthService.dart';

class UserAccessoryService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      };

  // 1. جلب جميع الإكسسوارات المتاحة للمستخدم
  static Future<Map<String, dynamic>> getAllAccessories() async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories');
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // 2. جلب جميع المفضلة
  static Future<Map<String, dynamic>> getFavorites() async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories?favourite=1');
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // 3. إضافة إلى المفضلة حسب id
  static Future<Map<String, dynamic>> addToFavorites(int id) async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories/$id/favourite');
      final response = await http.post(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // 4. عرض قطعة معينة حسب id
  static Future<Map<String, dynamic>> getAccessoryById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories/$id');
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // 5. إزالة من المفضلة حسب id
  static Future<Map<String, dynamic>> removeFromFavorites(int id) async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories/$id/favourite');
      final response = await http.delete(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // 6. طلب طلبية لقطعة معينة
  static Future<Map<String, dynamic>> placeOrder(int id, Map<String, dynamic> orderData) async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories/$id/order');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(orderData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // 7. عرض تفاصيل الطلب حسب id
  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    try {
      final url = Uri.parse('$baseUrl/user/accessories/orders/$orderId');
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  // دالة موحدة لمعالجة الردود
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': data['data'] ?? data,
          'message': data['message'] ?? 'نجحت العملية',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'حدث خطأ ما: ${response.statusCode}',
      };
    } catch (e) {
      return {'success': false, 'message': 'فشل في تحليل بيانات السيرفر'};
    }
  }
}
