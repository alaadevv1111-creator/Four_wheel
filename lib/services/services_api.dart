import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:four_wheels/services/AuthService.dart';

class ServiceApi {
  static const String baseUrl =
      'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (AuthService.token != null)
        'Authorization': 'Bearer ${AuthService.token}',
    };
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {};
    } catch (e) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> createService({
    required String phone,
    required String location,
    required String preferredDate,
    required String preferredTime,
    required String description,
    required String name,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/services/store');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'phone': phone,
          'location': location,
          'preferred_date': preferredDate,
          'preferred_time': preferredTime,
          'description': description,
          'name': name,
        }),
      );

      print('CREATE SERVICE STATUS: ${response.statusCode}');
      print('CREATE SERVICE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('CREATE SERVICE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getMyRequests() async {
    try {
      final url = Uri.parse('$baseUrl/services/my-requests');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('MY REQUESTS STATUS: ${response.statusCode}');
      print('MY REQUESTS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('MY REQUESTS ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getAdminServices({
    required String status,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/services?status=$status');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('ADMIN SERVICES STATUS: ${response.statusCode}');
      print('ADMIN SERVICES BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('ADMIN SERVICES ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getAdminServiceDetails({
    required int serviceId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/services/$serviceId');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('ADMIN SERVICE DETAILS STATUS: ${response.statusCode}');
      print('ADMIN SERVICE DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('ADMIN SERVICE DETAILS ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getAvailableMechanics({
    required String scheduledAt,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/admin/services/available-mechanics?scheduled_at=$scheduledAt',
      );

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('AVAILABLE MECHANICS STATUS: ${response.statusCode}');
      print('AVAILABLE MECHANICS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('AVAILABLE MECHANICS ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> acceptService({
    required int serviceId,
    required int mechanicId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/services/$serviceId/accept');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'mechanic_id': mechanicId,
        }),
      );

      print('ACCEPT SERVICE STATUS: ${response.statusCode}');
      print('ACCEPT SERVICE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('ACCEPT SERVICE ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getMechanicJobs() async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('MECHANIC JOBS STATUS: ${response.statusCode}');
      print('MECHANIC JOBS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('MECHANIC JOBS ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getMechanicJobDetails({
    required int jobId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs/$jobId');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('MECHANIC JOB DETAILS STATUS: ${response.statusCode}');
      print('MECHANIC JOB DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('MECHANIC JOB DETAILS ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> startRepair({
    required int jobId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs/$jobId/start');

      final response = await http.patch(
        url,
        headers: _headers,
      );

      print('START REPAIR STATUS: ${response.statusCode}');
      print('START REPAIR BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('START REPAIR ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> completeJob({
    required int jobId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs/$jobId/complete');

      final response = await http.patch(
        url,
        headers: _headers,
      );

      print('COMPLETE JOB STATUS: ${response.statusCode}');
      print('COMPLETE JOB BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('COMPLETE JOB ERROR: $e');
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };

    }
  }
  static Future<Map<String, dynamic>> deleteAdminService({
    required int serviceId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/services/$serviceId');

      final response = await http.delete(
        url,
        headers: _headers,
      );

      print('DELETE SERVICE STATUS: ${response.statusCode}');
      print('DELETE SERVICE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 204,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('DELETE SERVICE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

}