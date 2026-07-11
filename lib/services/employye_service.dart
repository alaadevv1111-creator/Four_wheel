import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:four_wheels/services/AuthService.dart';

class EmployeeService {
  static const String baseUrl =
      'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Future<Map<String, dynamic>> addEmployee({
    required String name,
    required String phone,
    required String email,
    required String role,
    required String status,
    required String hireDate,
    required String drivingLicensePath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/employees/add');

      final request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (AuthService.token != null)
          'Authorization': 'Bearer ${AuthService.token}',
      });

      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['role'] = role;
      request.fields['status'] = status;
      request.fields['hire_date'] = hireDate;

      if (drivingLicensePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'driving_license',
            drivingLicensePath,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('ADD EMP STATUS: ${response.statusCode}');
      print('ADD EMP BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Employee added successfully',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Add employee failed',
        'data': data,
      };
    } catch (e) {
      print('ADD EMP ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getEmployeeDetails(String id) async {
    try {
      final url = Uri.parse('$baseUrl/employees/details/$id');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      print('EMP DETAILS STATUS: ${response.statusCode}');
      print('EMP DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'data': data,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> showEmployees() async {
    try {
      final url = Uri.parse('$baseUrl/employees/all');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      print('SHOW EMP STATUS: ${response.statusCode}');
      print('SHOW EMP BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Employees loaded successfully',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to load employees',
        'data': data,
      };
    } catch (e) {
      print('SHOW EMP ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  /// بيتحقق هل المسار المعطى فعلياً ملف موجود على جهاز المستخدم (يعني صورة/ملف
  /// جديد لسا ما انرفع)، أو إنه مجرد مسار راجع من السيرفر (مثل "licenses/xxx.png"
  /// أو "employees/xxx.jpg") ما لازم نحاول نرفعه متل ملف محلي.
  static bool _isLocalFile(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('http')) return false;

    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> updateEmployee({
    required String id,
    required String name,
    required String phone,
    required String email,
    required String role,
    required String status,
    String imagePath = '',
    String drivingLicensePath = '',
  }) async {
    try {
      final url = Uri.parse('$baseUrl/employees/update/$id');

      final request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (AuthService.token != null)
          'Authorization': 'Bearer ${AuthService.token}',
      });

      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['role'] = role.trim().toLowerCase();
      request.fields['status'] = status;

      // منرفع الصورة/الرخصة بس إذا كانت فعلاً ملف جديد موجود على الجهاز.
      // إذا كانت مجرد مسار قديم راجع من السيرفر (licenses/... أو employees/...)
      // منتجاهلها لأنها أصلاً محفوظة بالباك إند وما في داعي نعيد رفعها.
      if (_isLocalFile(imagePath)) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imagePath,
          ),
        );
      }

      if (_isLocalFile(drivingLicensePath)) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'driving_license',
            drivingLicensePath,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('UPDATE EMP STATUS: ${response.statusCode}');
      print('UPDATE EMP BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Employee updated successfully',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Update employee failed',
        'data': data,
      };
    } catch (e) {
      print('UPDATE EMP ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteEmployee(String id) async {
    try {
      final url = Uri.parse('$baseUrl/employees/delete/$id');

      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      );

      print('DELETE EMPLOYEE STATUS: ${response.statusCode}');
      print('DELETE EMPLOYEE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204 ||
            data['success'] == true ||
            data['status'] == 'success',
        'message': data['message']?.toString() ?? '',
        'data': data,
      };
    } catch (e) {
      print('DELETE EMPLOYEE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }
  static Future<Map<String, dynamic>> getTotalEmployees() async {
    try {
      final url = Uri.parse('$baseUrl/employees/stats/total');
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (AuthService.token != null)
          'Authorization': 'Bearer ${AuthService.token}',
      },);

      print('TOTAL EMPLOYEES STATUS: ${response.statusCode}');
      print('TOTAL EMPLOYEES BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'total': data['total_employees'] ?? 0,
      };
    } catch (e) {
      print('TOTAL EMPLOYEES ERROR: $e');
      return {'success': false, 'total': 0};
    }
  }

  static Future<Map<String, dynamic>> getActiveEmployees() async {
    try {
      final url = Uri.parse('$baseUrl/employees/stats/active');
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (AuthService.token != null)
          'Authorization': 'Bearer ${AuthService.token}',
      },);
      print('TOTAL EMPLOYEES STATUS: ${response.statusCode}');
      print('TOTAL EMPLOYEES BODY: ${response.body}');

      print('ACTIVE EMPLOYEES STATUS: ${response.statusCode}');
      print('ACTIVE EMPLOYEES BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'active': data['active_now'] ?? 0,
      };
    } catch (e) {
      print('ACTIVE EMPLOYEES ERROR: $e');
      return {'success': false, 'active': 0};
    }
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } catch (_) {
      return {};
    }
  }
}