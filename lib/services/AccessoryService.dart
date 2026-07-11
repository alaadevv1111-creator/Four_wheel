import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/accessory_model.dart';
import 'AuthService.dart';

class AccessoryService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  // وظيفة جلب جميع الملحقات
  static Future<Map<String, dynamic>> getAllAccessories() async {
    try {
      final url = Uri.parse('$baseUrl/accessories/all');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'فشل جلب قائمة الملحقات.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال: $e',
      };
    }
  }

  // وظيفة جلب إجمالي عدد القطع
  static Future<Map<String, dynamic>> getTotalParts() async {
    try {
      final url = Uri.parse('$baseUrl/accessories/stats/total-parts');
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'total_parts': data['total_parts']};
      }
      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // وظيفة جلب القيمة الإجمالية للمخزون
  static Future<Map<String, dynamic>> getTotalValue() async {
    try {
      final url = Uri.parse('$baseUrl/accessories/stats/total-value');
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'total_value': data['total_value']};
      }
      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // وظيفة جلب تفاصيل ملحق معين
  static Future<Map<String, dynamic>> getAccessoryDetails(int id) async {
    try {
      final url = Uri.parse('$baseUrl/accessories/details/$id');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'فشل جلب تفاصيل القطعة.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال: $e',
      };
    }
  }

  // وظيفة إضافة ملحق جديد باستخدام الموديل
  static Future<Map<String, dynamic>> addAccessory(AccessoryModel accessory, {String? photoPath}) async {
    try {
      final url = Uri.parse('$baseUrl/accessories/add');

      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      });

      request.fields['name'] = accessory.name;
      request.fields['price'] = accessory.price.toString();
      request.fields['stock_quantity'] = accessory.stockQuantity.toString();
      request.fields['unit_id'] = accessory.unitId?.toString() ?? '';
      request.fields['category'] = accessory.category;

      if (photoPath != null && photoPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'تم إضافة القطعة بنجاح.',
          'data': data['data'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'فشل في إضافة القطعة.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateAccessory(int id, AccessoryModel accessory, {String? photoPath}) async {
    try {
      final url = Uri.parse('$baseUrl/accessories/update/$id');

      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      });

      request.fields['name'] = accessory.name;
      request.fields['price'] = accessory.price.toString();
      request.fields['stock_quantity'] = accessory.stockQuantity.toString();
      request.fields['unit_id'] = accessory.unitId?.toString() ?? '';
      request.fields['category'] = accessory.category;

      if (photoPath != null && photoPath.isNotEmpty && !photoPath.startsWith('http')) {
        request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Updated successfully',
          'data': data['data'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'فشل تحديث البيانات.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال: $e',
      };
    }
  }

  // وظيفة حذف ملحق
  static Future<Map<String, dynamic>> deleteAccessory(int id) async {
    try {
      final url = Uri.parse('$baseUrl/accessories/delete/$id');
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'تم حذف القطعة بنجاح.',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'فشل حذف القطعة.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال: $e',
      };
    }
  }
}