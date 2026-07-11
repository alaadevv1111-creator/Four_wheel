import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:four_wheels/services/AuthService.dart';

class DriverApi {
  static const String baseUrl =
      'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  // لما يجهز API الحقيقي للدرايفر غيري هاد المسار فقط لو مختلف
  static const String jobsPath = '/driver/jobs';

  static Map<String, String> get _headers {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (AuthService.token != null)
        'Authorization': 'Bearer ${AuthService.token}',
    };
  }

  static Future<Map<String, dynamic>> getDriverJobs() async {
    try {
      final url = Uri.parse('$baseUrl$jobsPath');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('DRIVER JOBS STATUS: ${response.statusCode}');
      print('DRIVER JOBS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('DRIVER JOBS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getDriverJobDetails({
    required int jobId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$jobsPath/$jobId');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('DRIVER JOB DETAILS STATUS: ${response.statusCode}');
      print('DRIVER JOB DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('DRIVER JOB DETAILS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> startDriverJob({
    required int jobId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$jobsPath/$jobId/start');

      final response = await http.patch(
        url,
        headers: _headers,
      );

      print('START DRIVER JOB STATUS: ${response.statusCode}');
      print('START DRIVER JOB BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('START DRIVER JOB ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> completeDriverJob({
    required int jobId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$jobsPath/$jobId/complete');

      final response = await http.patch(
        url,
        headers: _headers,
      );

      print('COMPLETE DRIVER JOB STATUS: ${response.statusCode}');
      print('COMPLETE DRIVER JOB BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('COMPLETE DRIVER JOB ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> submitDriverRating({
    required int jobId,
    required int rating,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$jobsPath/$jobId/rating');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'rating': rating,
        }),
      );

      print('DRIVER RATING STATUS: ${response.statusCode}');
      print('DRIVER RATING BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? '',
        'data': data,
      };
    } catch (e) {
      print('DRIVER RATING ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
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