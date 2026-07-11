// lib/services/ProfileService.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // لتحديد نوع الصورة تلقائياً
import 'AuthService.dart';

class ProfileService {
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev/api/v1';

  // الـ Headers الافتراضية لجميع الطلبات
  static Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  // 1. جلب بيانات البروفايل
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  // 2. تحديث الحقول النصية (الاسم، الهاتف، الايميل)
  static Future<Map<String, dynamic>> updateProfileFields(Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/profile/update'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Update failed'};
    }
  }

  // 3. رفع الصورة الشخصية (Multipart) المتوافقة تماماً مع البوستمان ✅
  static Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    try {
      final url = Uri.parse('$baseUrl/profile/update-image');
      var request = http.MultipartRequest('POST', url);

      // إضافة الـ Headers للـ Multipart
      request.headers.addAll({
        'Accept': 'application/json',
        if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
      });

      // استخراج الامتداد لتهيئة السيرفر لاستقبال أي امتداد للملفات بشكل احترافي
      String ext = imageFile.path.split('.').last.toLowerCase();

      // إرسال الملف الفعلي تحت الـ Key المسمى 'image' كما في البوستمان
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Image upload failed'};
    }
  }

  // 4. تحديث كلمة المرور
  static Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile/password/update'),
        headers: _headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Password update failed'};
    }
  }

  // 5. حذف الصورة الشخصية
  static Future<Map<String, dynamic>> deleteProfileImage() async {
    try {
      // تم تعديل الرابط بحذف كلمة /user/ ليتوافق مع معايير الـ API الموحدة لديكِ 🛠️
      final response = await http.delete(
        Uri.parse('$baseUrl/profile/delete-image'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Delete failed'};
    }
  }

  // دالة موحدة لمعالجة ردود السيرفر وفك تشفير الـ JSON
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decoded['data'], // يتم تسليم هذا الكائن للـ Controller لبناء الـ Model
          'message': decoded['message'] ?? 'Success'
        };
      }
      return {
        'success': false,
        'message': decoded['message'] ?? 'Error ${response.statusCode}'
      };
    } catch (e) {
      return {'success': false, 'message': 'Server error: ${response.statusCode}'};
    }
  }
}