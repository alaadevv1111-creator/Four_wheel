import 'package:four_wheels/models/user_cardetilesModel.dart';

class UserCarModel {
  final String id;
  final String model;
  final String brand;
  final String type;
  final String category;
  final String image;
  final String pricePerDay;
  final bool isAvailable;
  final String availabilityText;
  final bool isFavorite;
  final List<String> availableDates;

  UserCarModel({
    required this.id,
    required this.model,
    required this.brand,
    required this.type,
    required this.category,
    required this.image,
    required this.pricePerDay,
    required this.isAvailable,
    required this.availabilityText,
    this.isFavorite = false,
    this.availableDates = const [],
  });

  factory UserCarModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString().toLowerCase() ?? '';

    final isAvailableValue = json['is_available'] is bool
        ? json['is_available'] as bool
        : status == 'available';

    return UserCarModel(
      id: json['id']?.toString() ?? '',
      model: json['model']?.toString() ?? '',

      type: json['type']?.toString() ??
          json['category']?.toString() ??
          'Car',
      category: json['category']?.toString() ?? 'Car',

      pricePerDay: json['price_per_day']?.toString() ?? '0',
      image: json['car']?['image']?.toString() ??
          json['car']?['image_url']?.toString() ??
          json['car_image']?.toString() ??
          json['image']?.toString() ??
          '',

      brand: '${json['car']?['brand'] ?? ''} ${json['car']?['model'] ?? ''}'.trim().isEmpty
          ? json['car_name']?.toString() ?? 'Car Rental'
          : '${json['car']?['brand'] ?? ''} ${json['car']?['model'] ?? ''}'.trim(),
      isAvailable: isAvailableValue,
      availabilityText:
      isAvailableValue ? 'AVAILABLE TODAY' : 'NOT AVAILABLE',
      isFavorite: _boolFromJson(json['is_favorite']),
      availableDates: _datesFromJson(json['available_dates']),
    );
  }

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;

    final text = value?.toString().toLowerCase() ?? '';
    return text == 'true' || text == '1';
  }

  static List<String> _datesFromJson(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'brand': brand,
      'type': type,
      'category': category,
      'image': image,
      'price_per_day': pricePerDay,
      'is_available': isAvailable,
      'is_favorite': isFavorite,
      'available_dates': availableDates,
    };
  }

  CarDetailsModel toDetailsModel() {
    return CarDetailsModel(
      id: id,
      name: model,
      brand: brand,
      type: type,
      image: image,
      images: [
        image,
        image,
        image,
      ],
      pricePerDay: pricePerDay,
      isAvailable: isAvailable,
      availabilityText: availabilityText,
      description: 'This car is available for rental through Four Wheels.',
      rating: null,
      reviewsCount: null,
      pickupDate: '',
      pickupTime: '',
      returnDate: '',
      returnTime: '',
      additionalInfo: [
        'Brand: $brand',
        'Type: $type',
        'Daily price: \$$pricePerDay',
      ],
      requirements: [
        'Valid Driver License Required',
        'Minimum Age 21+',
        'ID Verification Required',
      ],
    );
  }

  UserCarModel copyWith({
    String? id,
    String? model,
    String? brand,
    String? type,
    String? category,
    String? image,
    String? pricePerDay,
    bool? isAvailable,
    String? availabilityText,
    bool? isFavorite,
    List<String>? availableDates,
  }) {
    return UserCarModel(
      id: id ?? this.id,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      category: category ?? this.category,
      image: image ?? this.image,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      isAvailable: isAvailable ?? this.isAvailable,
      availabilityText: availabilityText ?? this.availabilityText,
      isFavorite: isFavorite ?? this.isFavorite,
      availableDates: availableDates ?? this.availableDates,
    );
  }
}