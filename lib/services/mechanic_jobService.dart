import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:four_wheels/models/mechanic_jobmodel.dart';
import 'package:four_wheels/services/AuthService.dart';

class MechanicJobService {
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

  static Future<Map<String, dynamic>> getJobs() async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs');

      final response = await http.get(url, headers: _headers);

      print('MECHANIC JOBS STATUS: ${response.statusCode}');
      print('MECHANIC JOBS BODY: ${response.body}');

      final data = _decode(response.body);

      List list = [];
      final raw = data['data'];

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'];
      } else if (raw is Map<String, dynamic> && raw['jobs'] is List) {
        list = raw['jobs'];
      }

      final jobs = list
          .whereType<Map>()
          .map((item) => MechanicJobModel.fromJson(
        Map<String, dynamic>.from(item),
      ))
          .toList();

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'jobs': jobs,
      };
    } catch (e) {
      print('MECHANIC JOBS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'jobs': <MechanicJobModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getJobDetails(String id) async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs/$id');

      final response = await http.get(url, headers: _headers);

      print('MECHANIC JOB DETAILS STATUS: ${response.statusCode}');
      print('MECHANIC JOB DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      dynamic raw = data['data'];

      if (raw is Map<String, dynamic> && raw['job'] is Map<String, dynamic>) {
        raw = raw['job'];
      }

      MechanicJobModel? job;

      if (raw is Map<String, dynamic>) {
        job = MechanicJobModel.fromJson(raw);
      }

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'job': job,
      };
    } catch (e) {
      print('MECHANIC JOB DETAILS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'job': null,
      };
    }
  }

  static Future<Map<String, dynamic>> startJob(String id) async {
    return _patchJob('$baseUrl/mechanic/jobs/$id/start');
  }

  static Future<Map<String, dynamic>> completeJob(String id) async {
    return _patchJob('$baseUrl/mechanic/jobs/$id/complete');
  }

  static Future<Map<String, dynamic>> _patchJob(String endpoint) async {
    try {
      final url = Uri.parse(endpoint);

      final response = await http.patch(url, headers: _headers);

      print('MECHANIC PATCH URL: $url');
      print('MECHANIC PATCH STATUS: ${response.statusCode}');
      print('MECHANIC PATCH BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 ||
            response.statusCode == 201 ||
            data['success'] == true ||
            data['status'] == 'success',
        'message': data['message']?.toString() ?? '',
        'data': data,
      };
    } catch (e) {
      print('MECHANIC PATCH ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> rateCustomer({
    required String jobId,
    required int rating,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/mechanic/jobs/$jobId/rate');

      final response = await http.patch(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
        body: jsonEncode({
          'rating': rating,
        }),
      );

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message']?.toString() ?? '',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      if (body.trim().isEmpty) return {};

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