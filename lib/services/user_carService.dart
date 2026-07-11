import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:four_wheels/models/user_carmodel.dart';
import 'package:four_wheels/models/user_cardetilesModel.dart';
import 'package:four_wheels/services/AuthService.dart';

class UserCarService {
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

  static Future<Map<String, dynamic>> getUserCars({
    DateTime? startDate,
    DateTime? endDate,
    bool favoriteOnly = false,
  }) async {
    try {
      final query = <String, String>{};

      if (startDate != null && endDate != null) {
        query['start_date'] = _formatDate(startDate);
        query['end_date'] = _formatDate(endDate);
      }

      if (favoriteOnly) {
        query['favorite'] = '1';
      }

      final url = Uri.parse('$baseUrl/user/cars').replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('USER CARS STATUS: ${response.statusCode}');
      print('USER CARS BODY: ${response.body}');

      final data = _decode(response.body);
      final cars = _extractCars(data);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
        'cars': cars,
      };
    } catch (e) {
      print('USER CARS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'cars': <UserCarModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getCarDetails(String carId) async {
    try {
      final url = Uri.parse('$baseUrl/user/cars/$carId');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('USER CAR DETAILS STATUS: ${response.statusCode}');
      print('USER CAR DETAILS BODY: ${response.body}');

      final data = _decode(response.body);
      final car = _extractCarDetails(data);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
        'car': car,
      };
    } catch (e) {
      print('USER CAR DETAILS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'car': null,
      };
    }
  }

  static List<UserCarModel> _extractCars(dynamic data) {
    final list = _extractList(data);

    return list.map((item) {
      return UserCarModel.fromJson(item);
    }).toList();
  }

  static CarDetailsModel? _extractCarDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return CarDetailsModel.fromJson(data['data']);
      }

      if (data['car'] is Map<String, dynamic>) {
        return CarDetailsModel.fromJson(data['car']);
      }

      if (data['id'] != null || data['model'] != null) {
        return CarDetailsModel.fromJson(data);
      }
    }

    return null;
  }

  static List _extractList(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return data['data'];
      }

      if (data['cars'] is List) {
        return data['cars'];
      }

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['data'] is List) {
          return inner['data'];
        }

        if (inner['cars'] is List) {
          return inner['cars'];
        }
      }
    }

    if (data is List) {
      return data;
    }

    return [];
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

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}