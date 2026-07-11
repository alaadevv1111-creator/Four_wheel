import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:four_wheels/services/AuthService.dart';
import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/models/user_cardetilesModel.dart';
class BookingService {
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

  static Future<Map<String, dynamic>> getEmployeeProfile() async {
    try {
      final endpoints = [
        '$baseUrl/driver/profile',
        '$baseUrl/mechanic/profile',
        '$baseUrl/employee/profile',
        '$baseUrl/profile',
        '$baseUrl/me',
      ];

      for (final endpoint in endpoints) {
        final response = await http.get(
          Uri.parse(endpoint),
          headers: _headers,
        );

        print('EMP PROFILE URL: $endpoint');
        print('EMP PROFILE STATUS: ${response.statusCode}');
        print('EMP PROFILE BODY: ${response.body}');

        if (response.statusCode != 200) {
          continue;
        }

        final data = _decode(response.body);

        if (data['status'] == 'success' || data['success'] == true) {
          return {
            'success': true,
            'message': data['message']?.toString() ?? '',
            'data': data['data'],
          };
        }
      }

      return {
        'success': false,
        'message': 'Profile not found',
        'data': null,
      };
    } catch (e) {
      print('GET EMP PROFILE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> changeEmployeePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final endpoints = [
        '$baseUrl/driver/profile/password',
        '$baseUrl/mechanic/profile/password',
        '$baseUrl/employee/profile/password',
      ];

      final body = {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      for (final endpoint in endpoints) {
        final response = await http.put(
          Uri.parse(endpoint),
          headers: {
            ..._headers,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        );

        print('CHANGE PASSWORD URL: $endpoint');
        print('CHANGE PASSWORD STATUS: ${response.statusCode}');
        print('CHANGE PASSWORD BODY: ${response.body}');

        final data = _decode(response.body);

        if ((response.statusCode == 200 || response.statusCode == 201) &&
            (data['status'] == 'success' || data['success'] == true)) {
          return {
            'success': true,
            'message': data['message']?.toString() ?? 'Password updated',
          };
        }

        if (response.statusCode == 422 || response.statusCode == 400) {
          return {
            'success': false,
            'message': data['message']?.toString() ?? 'Invalid password data',
          };
        }
        if( response.statusCode == 422 || response.statusCode == 400) {
          return {
            'success': false,
            'message': data['message']?.toString() ?? 'Invalid password data',
          };
        }
      }

      return {
        'success': false,
        'message': 'Unable to update password',
      };
    } catch (e) {
      print('CHANGE PASSWORD ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> getBookingSetup({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/user/booking-setup?start_date=$startDate&end_date=$endDate',
      );

      final response = await http.get(url, headers: _headers);

      print('BOOKING SETUP STATUS: ${response.statusCode}');
      print('BOOKING SETUP BODY: ${response.body}');

      final data = _decode(response.body);
      final setupData = data['data'];

      final driversRaw = setupData is Map<String, dynamic>
          ? setupData['available_drivers']
          : [];

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'has_license': setupData is Map<String, dynamic>
            ? setupData['has_license'] == true
            : false,
        'license_number': setupData is Map<String, dynamic>
            ? setupData['license_number']?.toString() ?? ''
            : '',
        'drivers': driversRaw is List ? driversRaw : [],
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('BOOKING SETUP ERROR: $e');

      return {
        'success': false,
        'has_license': false,
        'license_number': '',
        'drivers': [],
        'message': 'connection error',
      };
    }
  }


  static Future<Map<String, dynamic>> addUserLicense({
    required String licenseNumber,
    required String licenseImagePath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile/license');

      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(_headers);

      request.fields['license_number'] = licenseNumber;

      request.files.add(
        await http.MultipartFile.fromPath(
          'license_image',
          licenseImagePath,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('ADD LICENSE STATUS: ${response.statusCode}');
      print('ADD LICENSE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            data['success'] == true,
        'message': data['message']?.toString() ?? 'Add license failed',
        'data': data['data'],
      };
    } catch (e) {
      print('ADD LICENSE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> createBooking({
    required String carId,
    required String startDate,
    required String endDate,
    required String totalPrice,
    required String pickupLocation,
    String driverId = '',
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/bookings');

      final Map<String, dynamic> body = {
        'car_id': int.tryParse(carId) ?? carId,
        'start_date': startDate,
        'end_date': endDate,
        'total_price': double.tryParse(totalPrice) ?? totalPrice,
        'pickup_location': pickupLocation,
      };

      if (driverId.isNotEmpty) {
        body['driver_id'] = int.tryParse(driverId) ?? driverId;
      }

      final response = await http.post(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('CREATE BOOKING STATUS: ${response.statusCode}');
      print('CREATE BOOKING BODY SENT: $body');
      print('CREATE BOOKING BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            data['success'] == true,
        'message': data['message']?.toString() ?? 'Booking failed',
        'data': data['data'],
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
      };
    } catch (e) {
      print('CREATE BOOKING ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'booking': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getAdminBookings({
    required String status,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/bookings?status=$status');

      final response = await http.get(url, headers: _headers);

      print('ADMIN BOOKINGS URL: $url');
      print('ADMIN BOOKINGS STATUS: ${response.statusCode}');
      print('ADMIN BOOKINGS BODY: ${response.body}');

      final data = _decode(response.body);

      final raw = data['data'];
      List list = [];

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'];
      }

      final bookings = list
          .whereType<Map<String, dynamic>>()
          .map((item) => DriverBookingTaskModel.fromJson(item))
          .toList();

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'bookings': bookings,
        'stats': data['stats'],
      };
    } catch (e) {
      print('ADMIN BOOKINGS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'bookings': <DriverBookingTaskModel>[],
        'stats': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getAdminBookingDetails({
    required String id,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/bookings/$id');

      final response = await http.get(url, headers: _headers);

      print('ADMIN BOOKING DETAILS STATUS: ${response.statusCode}');
      print('ADMIN BOOKING DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
      };
    } catch (e) {
      print('ADMIN BOOKING DETAILS ERROR: $e');

      return {
        'success': false,
        'booking': null,
      };
    }
  }

  static Future<Map<String, dynamic>> updateBookingStatus({
    required String id,
    required String status,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/admin/bookings/$id/status');

      final response = await http.patch(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      print('UPDATE BOOKING STATUS: ${response.statusCode}');
      print('UPDATE BOOKING BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['message']?.toString() ?? '',
        'data': data['data'],
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
      };
    } catch (e) {
      print('UPDATE BOOKING ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'booking': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getUserCars({
    String startDate = '',
    String endDate = '',
    bool favorite = false,
  }) async {
    try {
      final query = <String, String>{};

      if (favorite) {
        query['favorite'] = '1';
      }

      if (startDate.isNotEmpty) {
        query['start_date'] = startDate;
      }

      if (endDate.isNotEmpty) {
        query['end_date'] = endDate;
      }

      final url = Uri.parse('$baseUrl/user/cars').replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(url, headers: _headers);

      print('USER CARS STATUS: ${response.statusCode}');
      print('USER CARS URL: $url');
      print('USER CARS BODY: ${response.body}');

      final data = _decode(response.body);

      final list = data['data'] is List ? data['data'] : [];

      return {
        'success': response.statusCode == 200 &&
            (data['status'] == 'success' || data['success'] == true),
        'message': data['message']?.toString() ?? '',
        'cars': list.map<CarDetailsModel>((item) {
          return CarDetailsModel.fromJson(item);
        }).toList(),
      };
    } catch (e) {
      print('USER CARS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'cars': <CarDetailsModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> addCarToFavorite({
    required String carId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/cars/$carId/favorite');

      final response = await http.post(url, headers: _headers);

      print('ADD FAVORITE STATUS: ${response.statusCode}');
      print('ADD FAVORITE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('ADD FAVORITE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> removeCarFromFavorite({
    required String carId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/cars/$carId/favorite');

      final response = await http.delete(url, headers: _headers);

      print('REMOVE FAVORITE STATUS: ${response.statusCode}');
      print('REMOVE FAVORITE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('REMOVE FAVORITE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }
  static Future<Map<String, dynamic>> getDriverBookings({
    String status = '',
  }) async {
    try {
      final query = <String, String>{};

      if (status.isNotEmpty) {
        query['status'] = status;
      }

      final url = Uri.parse('$baseUrl/driver/bookings').replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(url, headers: _headers);

      print('DRIVER BOOKINGS URL: $url');
      print('DRIVER BOOKINGS STATUS: ${response.statusCode}');
      print('DRIVER BOOKINGS BODY: ${response.body}');

      final data = _decode(response.body);

      final raw = data['data'];
      List list = [];

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'];
      }

      final bookings = list
          .whereType<Map<String, dynamic>>()
          .map((item) => DriverBookingTaskModel.fromJson(item))
          .toList();

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'bookings': bookings,
      };
    } catch (e) {
      print('DRIVER BOOKINGS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'bookings': <DriverBookingTaskModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getDriverBookingDetails({
    required String id,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/driver/bookings/$id');

      final response = await http.get(url, headers: _headers);

      print('DRIVER BOOKING DETAILS STATUS: ${response.statusCode}');
      print('DRIVER BOOKING DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('DRIVER BOOKING DETAILS ERROR: $e');

      return {
        'success': false,
        'booking': null,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> startDriverBooking({
    required String id,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/driver/bookings/$id/start');

      final response = await http.patch(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
      );

      print('START DRIVER BOOKING STATUS: ${response.statusCode}');
      print('START DRIVER BOOKING BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
      };
    } catch (e) {
      print('START DRIVER BOOKING ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'booking': null,
      };
    }
  }

  static Future<Map<String, dynamic>> completeDriverBooking({
    required String id,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/driver/bookings/$id/complete');

      final response = await http.patch(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
      );

      print('COMPLETE DRIVER BOOKING STATUS: ${response.statusCode}');
      print('COMPLETE DRIVER BOOKING BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
      };
    } catch (e) {
      print('COMPLETE DRIVER BOOKING ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'booking': null,
      };
    }
  }

  static Future<Map<String, dynamic>> rateUserByDriver({
    required String id,
    required int rating,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/driver/bookings/$id/rate-user');

      final response = await http.post(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'rating': rating,
        }),
      );

      print('RATE USER STATUS: ${response.statusCode}');
      print('RATE USER BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'booking': data['data'] is Map<String, dynamic>
            ? DriverBookingTaskModel.fromJson(data['data'])
            : null,
      };
    } catch (e) {
      print('RATE USER ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'booking': null,
      };
    }
  }
  static Future<Map<String, dynamic>> getDashboardRecentBookings() async {
    try {
      final url = Uri.parse('$baseUrl/dashboard/recent-bookings');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('DASHBOARD RECENT BOOKINGS STATUS: ${response.statusCode}');
      print('DASHBOARD RECENT BOOKINGS BODY: ${response.body}');

      final data = _decode(response.body);

      final raw = data['data'];
      List list = [];

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'];
      }

      final bookings = list
          .whereType<Map<String, dynamic>>()
          .map((item) => DriverBookingTaskModel.fromJson(item))
          .toList();

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'bookings': bookings,
      };
    } catch (e) {
      print('DASHBOARD RECENT BOOKINGS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'bookings': <DriverBookingTaskModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> deleteBooking(String id) async {
    try {
      final url = Uri.parse('$baseUrl/admin/bookings/$id');

      final response = await http.delete(url, headers: _headers);

      print('DELETE BOOKING STATUS: ${response.statusCode}');
      print('DELETE BOOKING BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('DELETE BOOKING ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }
  static Future<Map<String, dynamic>> getUserRentalOrders({
    String status = '',
  }) async {
    try {
      final query = <String, String>{};

      if (status.isNotEmpty) {
        query['status'] = status;
      }

      final url = Uri.parse('$baseUrl/user/my-orders/rentals').replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(url, headers: _headers);

      print('USER RENTAL ORDERS URL: $url');
      print('USER RENTAL ORDERS STATUS: ${response.statusCode}');
      print('USER RENTAL ORDERS BODY: ${response.body}');

      final data = _decode(response.body);

      final raw = data['data'];
      List list = [];

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'];
      }

      final orders = list
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'orders': orders,
      };
    } catch (e) {
      print('USER RENTAL ORDERS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'orders': <Map<String, dynamic>>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getUserServiceOrders({
    String status = '',
  }) async {
    try {
      final query = <String, String>{};

      if (status.isNotEmpty) {
        query['status'] = status;
      }

      final url = Uri.parse('$baseUrl/user/my-orders/services').replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(url, headers: _headers);

      print('USER SERVICE ORDERS URL: $url');
      print('USER SERVICE ORDERS STATUS: ${response.statusCode}');
      print('USER SERVICE ORDERS BODY: ${response.body}');

      final data = _decode(response.body);

      final raw = data['data'];
      List list = [];

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'];
      }

      final orders = list
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      return {
        'success': response.statusCode == 200 &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
        'orders': orders,
      };
    } catch (e) {
      print('USER SERVICE ORDERS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'orders': <Map<String, dynamic>>[],
      };
    }
  }

  static Future<Map<String, dynamic>> cancelUserRentalOrder({
    required String id,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/rentals/$id/cancel');

      final response = await http.post(url, headers: _headers);

      print('CANCEL USER RENTAL STATUS: ${response.statusCode}');
      print('CANCEL USER RENTAL BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('CANCEL USER RENTAL ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> cancelUserServiceOrder({
    required String id,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/services/$id/cancel');

      final response = await http.post(url, headers: _headers);

      print('CANCEL USER SERVICE STATUS: ${response.statusCode}');
      print('CANCEL USER SERVICE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('CANCEL USER SERVICE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  // ============ RATING ENDPOINTS (My Orders) ============

  static Future<Map<String, dynamic>> rateAccessoryOrder({
    required String id,
    required int rating,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/user/my-orders/accessories/$id/rate?rating=$rating',
      );

      final response = await http.get(url, headers: _headers);

      print('RATE ACCESSORY STATUS: ${response.statusCode}');
      print('RATE ACCESSORY BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('RATE ACCESSORY ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> rateCarOrder({
    required String id,
    required int rating,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/rentals/$id/rate-car');

      final response = await http.post(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'rating': rating}),
      );

      print('RATE CAR STATUS: ${response.statusCode}');
      print('RATE CAR BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('RATE CAR ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> rateDriverOrder({
    required String id,
    required int rating,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/rentals/$id/rate-driver');

      final response = await http.post(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'rating': rating}),
      );

      print('RATE DRIVER STATUS: ${response.statusCode}');
      print('RATE DRIVER BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('RATE DRIVER ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static Future<Map<String, dynamic>> rateServiceOrder({
    required String id,
    required int rating,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/my-orders/services/$id/rate');

      final response = await http.post(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'rating': rating}),
      );

      print('RATE SERVICE STATUS: ${response.statusCode}');
      print('RATE SERVICE BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': (response.statusCode == 200 || response.statusCode == 201) &&
            (data['success'] == true || data['status'] == 'success'),
        'message': data['message']?.toString() ?? '',
      };
    } catch (e) {
      print('RATE SERVICE ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
      };
    }
  }

  static List _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      if (data['data'] is List) return data['data'];

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['data'] is List) return inner['data'];
      }
    }

    return [];
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'raw': decoded};
    } catch (_) {
      return {'raw': body};
    }
  }
}