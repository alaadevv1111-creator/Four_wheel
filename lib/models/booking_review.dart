import 'package:four_wheels/models/emp_model.dart';

class BookingReviewModel {
  final dynamic car;

  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;

  final String pickupLocation;
  final String returnLocation;

  final bool hasLicense;
  final String licensePath;
  final String licenseNumber;

  final EmployeeModel? selectedDriver;

  BookingReviewModel({
    required this.car,
    this.pickupDate = '',
    this.pickupTime = '',
    this.returnDate = '',
    this.returnTime = '',
    this.pickupLocation = '',
    this.returnLocation = '',
    this.hasLicense = false,
    this.licensePath = '',
    this.licenseNumber = '',
    this.selectedDriver,
  });

  String get carId => _readCarValue(['id']);
  String get carImage => _readCarValue(['image', 'imageUrl', 'image_url']);
  String get carName => _readCarValue(['name', 'model']);
  String get carBrand => _readCarValue(['brand']);
  String get carType => _readCarValue(['type'], fallback: 'Car');
  String get carPricePerDay => _readCarValue(['pricePerDay', 'dailyPrice', 'price_per_day']);

  String _readCarValue(List<String> keys, {String fallback = ''}) {
    if (car == null) return fallback;

    if (car is Map<String, dynamic>) {
      for (final key in keys) {
        final value = car[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      return fallback;
    }

    for (final key in keys) {
      try {
        dynamic value;

        switch (key) {
          case 'id':
            value = car.id;
            break;
          case 'image':
            value = car.image;
            break;
          case 'imageUrl':
            value = car.imageUrl;
            break;
          case 'image_url':
            value = car.imageUrl;
            break;
          case 'name':
            value = car.name;
            break;
          case 'model':
            value = car.model;
            break;
          case 'brand':
            value = car.brand;
            break;
          case 'type':
            value = car.type;
            break;
          case 'pricePerDay':
            value = car.pricePerDay;
            break;
          case 'dailyPrice':
            value = car.dailyPrice;
            break;
          case 'price_per_day':
            value = car.pricePerDay;
            break;
        }

        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      } catch (_) {}
    }

    return fallback;
  }
}