import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:four_wheels/models/car_model.dart';
import 'package:four_wheels/services/AuthService.dart';
import 'package:four_wheels/widgets/Custom_CarCard.dart';
import 'package:four_wheels/models/user_cardetilesModel.dart';

class CarService {
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

  static String carStatusToApi(CarStatus status) {
    switch (status) {
      case CarStatus.available:
        return 'available';
      case CarStatus.rented:
        return 'rented';
      case CarStatus.maintenance:
        return 'maintenance';
    }
  }

  static Future<Map<String, dynamic>> addCar({
    required CarModel car,
    required String imagePath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/cars/add');

      final request = http.MultipartRequest('POST', url);

      request.headers.addAll(_headers);

      request.fields['brand'] = car.brand;
      request.fields['model'] = car.model;
      request.fields['year'] = car.year;
      request.fields['plate_number'] = car.licensePlate;
      request.fields['price_per_day'] = car.dailyPrice;
      request.fields['status'] = carStatusToApi(car.status);

      if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imagePath,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('ADD CAR STATUS: ${response.statusCode}');
      print('ADD CAR BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Car added successfully',
          'data': data,
          'car': _extractCar(data),
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Add car failed',
        'data': data,
        'car': null,
      };
    } catch (e) {
      print('ADD CAR ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'car': null,
      };
    }
  }

  static Future<Map<String, dynamic>> updateCar({
    required CarModel car,
    required String imagePath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/cars/update/${car.id}');

      final request = http.MultipartRequest('POST', url);

      request.headers.addAll(_headers);

      request.fields['brand'] = car.brand;
      request.fields['model'] = car.model;
      request.fields['year'] = car.year;
      request.fields['plate_number'] = car.licensePlate;
      request.fields['price_per_day'] = car.dailyPrice;
      request.fields['status'] = carStatusToApi(car.status);

      if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imagePath,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('UPDATE CAR STATUS: ${response.statusCode}');
      print('UPDATE CAR BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Car updated successfully',
          'data': data,
          'car': _extractCar(data),
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Update car failed',
        'data': data,
        'car': null,
      };
    } catch (e) {
      print('UPDATE CAR ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'car': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getCarDetails(String id) async {
    try {
      final url = Uri.parse('$baseUrl/cars/details/$id');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('CAR DETAILS STATUS: ${response.statusCode}');
      print('CAR DETAILS BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Car loaded successfully',
          'data': data,
          'car': _extractCar(data),
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Load car failed',
        'data': data,
        'car': null,
      };
    } catch (e) {
      print('CAR DETAILS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'car': null,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteCar(String id) async {
    try {
      final url = Uri.parse('$baseUrl/cars/delete/$id');

      final response = await http.delete(
        url,
        headers: _headers,
      );

      print('DELETE CAR STATUS: ${response.statusCode}');
      print('DELETE CAR BODY: ${response.body}');

      final data = _decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': data['message'] ?? 'Car deleted successfully',
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Delete car failed',
        'data': data,
      };
    } catch (e) {
      print('DELETE CAR ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> getTotalCars() async {
    try {
      final url = Uri.parse('$baseUrl/cars/total');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('TOTAL CARS STATUS: ${response.statusCode}');
      print('TOTAL CARS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
        'count': _extractCount(data),
        'cars': _extractCars(data),
      };
    } catch (e) {
      print('TOTAL CARS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'count': 0,
        'cars': <CarModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getAvailableCars() async {
    try {
      final url = Uri.parse('$baseUrl/cars/available');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('AVAILABLE CARS STATUS: ${response.statusCode}');
      print('AVAILABLE CARS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
        'count': _extractCount(data),
        'cars': _extractCars(data),
      };
    } catch (e) {
      print('AVAILABLE CARS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'count': 0,
        'cars': <CarModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getRentedCars() async {
    try {
      final url = Uri.parse('$baseUrl/cars/rented');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('RENTED CARS STATUS: ${response.statusCode}');
      print('RENTED CARS BODY: ${response.body}');

      final data = _decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
        'count': _extractCount(data),
        'cars': _extractCars(data),
      };
    } catch (e) {
      print('RENTED CARS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'count': 0,
        'cars': <CarModel>[],
      };
    }
  }

  static Future<Map<String, dynamic>> getAllCars() async {
    try {
      final url = Uri.parse('$baseUrl/cars/all');

      final response = await http.get(
        url,
        headers: _headers,
      );

      print('ALL CARS STATUS: ${response.statusCode}');
      print('ALL CARS BODY: ${response.body}');

      final data = _decode(response.body);
      final cars = _extractCars(data);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? '',
        'data': data,
        'cars': cars,
        'totalCount': cars.length,
        'availableCount': cars.where((car) {
          return CarModel.statusToApi(car.status) == 'available';
        }).length,
        'rentedCount': cars.where((car) {
          return CarModel.statusToApi(car.status) == 'rented';
        }).length,
      };
    } catch (e) {
      print('ALL CARS ERROR: $e');

      return {
        'success': false,
        'message': 'connection error',
        'data': null,
        'cars': <CarModel>[],
        'totalCount': 0,
        'availableCount': 0,
        'rentedCount': 0,
      };
    }
  }

  static Future<Map<String, dynamic>> getAdminCars() async {
    return getAllCars();
  }

  static List<CarModel> _extractCars(dynamic data) {
    final list = _extractList(data);

    return list.map((item) {
      return CarModel.fromJson(item);
    }).toList();
  }

  static List _extractList(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return data['data'];
      }

      if (data['cars'] is List) {
        return data['cars'];
      }

      if (data['available'] is List) {
        return data['available'];
      }

      if (data['rented'] is List) {
        return data['rented'];
      }

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['data'] is List) {
          return inner['data'];
        }

        if (inner['cars'] is List) {
          return inner['cars'];
        }

        if (inner['available'] is List) {
          return inner['available'];
        }

        if (inner['rented'] is List) {
          return inner['rented'];
        }
      }
    }

    if (data is List) {
      return data;
    }

    return [];
  }
  static Future<Map<String, dynamic>> getUserCars({
    String startDate = '',
    String endDate = '',
    bool favorite = false,
  }) async {
    try {
      final query = <String, String>{};

      if (startDate.isNotEmpty) {
        query['start_date'] = startDate;
      }

      if (endDate.isNotEmpty) {
        query['end_date'] = endDate;
      }

      if (favorite) {
        query['favorite'] = '1';
      }

      final url = Uri.parse('$baseUrl/user/cars').replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(url, headers: _headers);

      print('USER CARS STATUS: ${response.statusCode}');
      print('USER CARS BODY: ${response.body}');

      final data = jsonDecode(response.body);

      final list = data['data'] is List ? data['data'] : [];

      return {
        'success': response.statusCode == 200 && data['status'] == 'success',
        'cars': list.map<CarDetailsModel>((item) {
          return CarDetailsModel.fromJson(item);
        }).toList(),
      };
    } catch (e) {
      print('USER CARS ERROR: $e');

      return {
        'success': false,
        'cars': <CarDetailsModel>[],
      };
    }
  }

  static int _extractCount(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['count'] != null) {
        return int.tryParse(data['count'].toString()) ?? 0;
      }

      if (data['total'] != null) {
        return int.tryParse(data['total'].toString()) ?? 0;
      }

      if (data['total_cars'] != null) {
        return int.tryParse(data['total_cars'].toString()) ?? 0;
      }

      if (data['available'] is int) {
        return data['available'];
      }

      if (data['rented'] is int) {
        return data['rented'];
      }

      if (data['data'] is int) {
        return data['data'];
      }

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['count'] != null) {
          return int.tryParse(inner['count'].toString()) ?? 0;
        }

        if (inner['total'] != null) {
          return int.tryParse(inner['total'].toString()) ?? 0;
        }

        if (inner['total_cars'] != null) {
          return int.tryParse(inner['total_cars'].toString()) ?? 0;
        }
      }
    }

    final list = _extractList(data);
    return list.length;
  }

  static CarModel? _extractCar(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['car'] is Map<String, dynamic>) {
        return CarModel.fromJson(data['car']);
      }

      if (data['vehicle'] is Map<String, dynamic>) {
        return CarModel.fromJson(data['vehicle']);
      }

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['car'] is Map<String, dynamic>) {
          return CarModel.fromJson(inner['car']);
        }

        if (inner['vehicle'] is Map<String, dynamic>) {
          return CarModel.fromJson(inner['vehicle']);
        }

        if (inner['id'] != null || inner['model'] != null) {
          return CarModel.fromJson(inner);
        }
      }

      if (data['id'] != null || data['model'] != null) {
        return CarModel.fromJson(data);
      }
    }

    return null;
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