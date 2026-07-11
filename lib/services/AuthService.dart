import 'dart:convert';
import 'package:four_wheels/models/ForgetPassword_model.dart';
import 'package:four_wheels/models/ResetPassword_model.dart';
import 'package:four_wheels/models/VerifyCode_model.dart';
import 'package:four_wheels/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:four_wheels/models/register_model.dart';
import 'package:four_wheels/models/login_model.dart';
import 'package:four_wheels/models/GoogleAuth_model.dart';
import 'package:four_wheels/models/CheckEmail_model.dart';

class AuthService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';


  static String? token;
  static Future<Map<String, dynamic>> register(RegisterModel user) async {
    try {
      final url = Uri.parse('$baseUrl/register');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      final data = _Decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['token'] != null) {
          token = data['token'];
        }
        return {
          'success': true,
          'message': data['message'] ?? 'Registered successfully',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Register failed',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }
  static Future<Map<String, dynamic>> login(LoginModel user) async {
    print("login start");
    try {
      final url = Uri.parse('$baseUrl/login');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final data = _Decode(response.body);

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          token = data['token'];
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login failed',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }
  static Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse('$baseUrl/logout');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final data = _Decode(response.body);

      if (response.statusCode == 200) {
        token = null;

        return {
          'success': true,
          'message': data['message'] ?? 'Logout successful',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Logout failed',
        'data': data,
      };
    }catch(e){

      return{
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }
  static Future<Map<String, dynamic>> forgotPassword(ForgotPasswordModel user,) async {
    try {
      final url = Uri.parse('$baseUrl/forgot-password');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final data = _Decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      }

      return {'success': false, 'message': data['message']};
    }catch(e){
      return{
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }


  static Future<Map<String, dynamic>> verifyCode(VerifyCodeModel user) async {
    try {
      final url = Uri.parse('$baseUrl/verify-code');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final data = _Decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true};
      }

      return {'success': false, 'message': data['message']};
    }catch(e){
      return{
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }




    static Future<Map<String, dynamic>> googleLogin(
    GoogleAuthModel user,
    ) async {
      try {
        final url = Uri.parse('$baseUrl/google-login');

        final response = await http.post(
          url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(user.toJson()),
        );

        final data = _Decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (data['token'] != null) {
            token = data['token'];
          }

          return {
            'success': true,
            'message': data['message'] ?? 'Google login successful',
            'data': data,
          };
        }

        return {
          'success': false,
          'message': data['message'] ?? 'Google login failed',
          'data': data,
        };
      }catch(e){
        return{
          'success': false,
          'massage': 'connection error',
          'data': null
        };
      }
    }

  static Future<Map<String, dynamic>> checkEmail(
      CheckEmailModel user,
      ) async {
    try {
      final url = Uri.parse('$baseUrl/check-email');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final data = _Decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Email exists',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Email does not exist',
        'data': data,
      };
    }catch(e){
      return{
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }

  static Future<Map<String, dynamic>> resetPassword(ResetPasswordModel user) async {
    try {
      final url = Uri.parse('$baseUrl/update-password');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final data = _Decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      }

      return {'success': false, 'message': data['message']};
    }catch(e){
      return{
        'success': false,
        'massage': 'connection error',
        'data': null
      };
    }
  }
  static void clearLocalAuth() {
    token = null;
    // userRole = null;
    print(" Auth memory cleared: Token and Role are now null");
  }

  static Map<String, dynamic> _Decode(String body) {
    try {
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