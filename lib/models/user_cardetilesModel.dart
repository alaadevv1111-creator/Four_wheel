class CarDetailsModel {
  final String id;
  final String name;
  final String brand;
  final String type;
  final String image;
  final List<String> images;

  final String pricePerDay;
  final bool isAvailable;
  final String availabilityText;

  final String description;

  final double? rating;
  final int? reviewsCount;

  final bool isFavorite;

  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;

  final List<String> additionalInfo;
  final List<String> requirements;

  CarDetailsModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.image,
    required this.images,
    required this.pricePerDay,
    required this.isAvailable,
    required this.availabilityText,
    required this.description,
    this.rating,
    this.reviewsCount,
    this.isFavorite = false,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.additionalInfo,
    required this.requirements,
  });

  CarDetailsModel copyWith({
    String? pickupDate,
    String? pickupTime,
    String? returnDate,
    String? returnTime,
    bool? isFavorite,
  }) {
    return CarDetailsModel(
      id: id,
      name: name,
      brand: brand,
      type: type,
      image: image,
      images: images,
      pricePerDay: pricePerDay,
      isAvailable: isAvailable,
      availabilityText: availabilityText,
      rating: rating,
      reviewsCount: reviewsCount,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description,
      additionalInfo: additionalInfo,
      requirements: requirements,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      returnDate: returnDate ?? this.returnDate,
      returnTime: returnTime ?? this.returnTime,
    );
  }

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString().toLowerCase() ?? '';

    final isAvailableValue = json['is_available'] is bool
        ? json['is_available'] as bool
        : status == 'available';

    final imageValue = json['image']?.toString() ??
        json['image_url']?.toString() ??
        '';

    // نتحقق من كل الصيغ المحتملة لحقل المفضلة القادم من الباك إند
    final isFavoriteValue = json['is_favorite'] == true ||
        json['is_favorite']?.toString() == '1' ||
        json['is_favorite']?.toString().toLowerCase() == 'true' ||
        json['isFavorite'] == true ||
        json['favorite'] == true;

    return CarDetailsModel(
      id: json['id']?.toString() ?? '',
      name: json['model']?.toString() ??
          json['name']?.toString() ??
          '',
      brand: json['brand']?.toString() ?? '',
      type: json['type']?.toString() ??
          json['category']?.toString() ??
          'Car',
      image: imageValue,
      images: _imagesFromJson(json['images'], imageValue),
      pricePerDay: json['price_per_day']?.toString() ?? '0',
      isAvailable: isAvailableValue,
      availabilityText:
      isAvailableValue ? 'AVAILABLE TODAY' : 'NOT AVAILABLE',
      description: json['description']?.toString() ??
          'This car is available for rental through Four Wheels.',
      rating: _doubleFromJson(json['rating']),
      reviewsCount: _intFromJson(json['rating_count']),
      isFavorite: isFavoriteValue,
      pickupDate: json['pickup_date']?.toString() ?? '',
      pickupTime: json['pickup_time']?.toString() ?? '',
      returnDate: json['return_date']?.toString() ?? '',
      returnTime: json['return_time']?.toString() ?? '',
      additionalInfo: [
        'Brand: ${json['brand']?.toString() ?? ''}',
        'Year: ${json['year']?.toString() ?? ''}',
        'Plate: ${json['plate_number']?.toString() ?? ''}',
      ],
      requirements: [
        'Valid Driver License Required',
        'Minimum Age 21+',
        'ID Verification Required',
      ],
    );
  }

  static List<String> _imagesFromJson(dynamic value, String fallback) {
    if (value is List) {
      final list = value.map((item) => item.toString()).toList();

      if (list.isNotEmpty) {
        return list;
      }
    }

    if (fallback.isNotEmpty) {
      return [
        fallback,
        fallback,
        fallback,
      ];
    }

    return [];
  }

  static double? _doubleFromJson(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  static int? _intFromJson(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}