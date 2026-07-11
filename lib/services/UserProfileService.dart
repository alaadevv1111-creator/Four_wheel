import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/user_profile_model.dart';
import 'AuthService.dart';

class UserProfileService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      };

  // 1. Get User Profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final url = Uri.parse('$baseUrl/user/profile');
      final response = await http.get(url, headers: _headers);

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'] ?? data,
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Failed to load profile',
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  // 2. Update User Profile with Multipart support for images
  static Future<Map<String, dynamic>> updateProfile({
    required UserProfileModel profile,
    File? profileImage,
    File? licenseImage,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile/update');
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      });

      // Add text fields
      profile.toJson().forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add Profile Image
      if (profileImage != null) {
        String ext = profileImage.path.split('.').last.toLowerCase();
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          profileImage.path,
          contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
        ));
      }

      // Add License Image
      if (licenseImage != null) {
        String ext = licenseImage.path.split('.').last.toLowerCase();
        request.files.add(await http.MultipartFile.fromPath(
          'license_image',
          licenseImage.path,
          contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = _decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Profile updated successfully',
          'data': data['data'] ?? data,
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Update failed',
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  // 3. Update Password
  static Future<Map<String, dynamic>> updatePassword(UpdatePasswordModel passwordData) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile/password');
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(passwordData.toJson()),
      );

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password updated successfully',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Password update failed',
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {};
    }
  }
}
