class DriverBookingTaskModel {
  final String id;
  final String carId;

  final String driverName;
  final String driverImage;

  final String customerName;
  final String customerPhone;

  final String carName;
  final String carImage;
  final String plateNumber;
  final String vin;

  final String pickupLocation;
  final String bookingDate;
  final String endDate;
  final String createdAt;

  final String price;
  final String status;

  final double? customerRating;
  final int? tripRating;
  final DateTime? completedAt;

  final String licenseTitle;
  final String licenseNumber;
  final String licenseExpiry;
  final String licenseImage;
  final bool licenseVerified;

  DriverBookingTaskModel({
    required this.id,
    this.carId = '',
    this.driverName = '',
    this.driverImage = '',
    required this.customerName,
    required this.customerPhone,
    required this.carName,
    required this.carImage,
    required this.plateNumber,
    required this.vin,
    required this.pickupLocation,
    required this.bookingDate,
    this.endDate = '',
    this.createdAt = '',
    required this.price,
    required this.status,
    this.customerRating,
    this.tripRating,
    this.completedAt,
    this.licenseTitle = '',
    this.licenseNumber = '',
    this.licenseExpiry = '',
    this.licenseImage = '',
    this.licenseVerified = false,
  });

  factory DriverBookingTaskModel.fromJson(Map<String, dynamic> json) {
    final car = _mapValue(json['car']);
    final customer = _mapValue(json['customer'] ?? json['user']);
    final driver = _mapValue(json['driver'] ?? json['employee']);

    final brand = car['brand']?.toString() ?? '';
    final model = car['model']?.toString() ?? '';
    final fullCarName = '$brand $model'.trim();

    return DriverBookingTaskModel(
      id: json['id']?.toString() ?? '',

      // معرّف السيارة نفسها - ضروري عشان نقدر نعدّل حالتها لاحقاً
      carId: car['id']?.toString() ??
          json['car_id']?.toString() ??
          '',

      driverName: driver['name']?.toString() ??
          json['driver_name']?.toString() ??
          json['employee_name']?.toString() ??
          '',

      driverImage: driver['image']?.toString() ??
          driver['image_url']?.toString() ??
          json['driver_image']?.toString() ??
          '',

      customerName: customer['name']?.toString() ??
          json['customer_name']?.toString() ??
          json['user_name']?.toString() ??
          '',

      customerPhone: customer['phone']?.toString() ??
          customer['phone_number']?.toString() ??
          json['customer_phone']?.toString() ??
          json['user_phone']?.toString() ??
          '',

      carName: fullCarName.isNotEmpty
          ? fullCarName
          : car['name']?.toString() ??
          json['car_name']?.toString() ??
          json['vehicle_model']?.toString() ??
          '',

      carImage: car['image']?.toString() ??
          car['image_url']?.toString() ??
          car['photo']?.toString() ??
          car['photo_url']?.toString() ??
          car['main_image']?.toString() ??
          car['car_image']?.toString() ??
          json['car_image']?.toString() ??
          '',

      plateNumber: car['plate_number']?.toString() ??
          car['license_plate']?.toString() ??
          json['plate_number']?.toString() ??
          '',

      vin: car['vin']?.toString() ?? json['vin']?.toString() ?? '-',

      pickupLocation: json['pickup_location']?.toString() ??
          json['location']?.toString() ??
          '',

      bookingDate: json['start_date']?.toString() ??
          json['booking_date']?.toString() ??
          json['pickup_date']?.toString() ??
          '',

      endDate: json['end_date']?.toString() ?? '',

      createdAt: json['created_at']?.toString() ?? '',

      completedAt: json['completed_at'] == null
          ? null
          : DateTime.tryParse(json['completed_at'].toString()),

      price: json['total_price']?.toString() ??
          json['price']?.toString() ??
          json['total']?.toString() ??
          '',

      status: _uiStatus(json['status']?.toString() ?? 'pending'),

      customerRating: json['customer_rating'] == null
          ? null
          : double.tryParse(json['customer_rating'].toString()),

      tripRating: json['trip_rating'] ??
          json['driver_rating'] ??
          json['rating'] ??
          null,


      licenseTitle: driver['license_title']?.toString() ??
          driver['job_title']?.toString() ??
          'Driver License',

      licenseNumber: driver['license_number']?.toString() ??
          json['license_number']?.toString() ??
          '',

      licenseExpiry: driver['license_expiry']?.toString() ??
          driver['license_expire_date']?.toString() ??
          json['license_expiry']?.toString() ??
          '',

      licenseImage: driver['license_image']?.toString() ??
          json['license_image']?.toString() ??
          '',

      licenseVerified: driver['license_verified'] == true ||
          driver['license_verified']?.toString() == '1' ||
          driver['license_verified']?.toString().toLowerCase() == 'true',
    );
  }
  bool get canDriverRate {
    if (tripRating != null) return false;

    if (completedAt != null) {
      final diff = DateTime.now().difference(completedAt!);
      return diff.inHours < 24;
    }

    return status.toLowerCase().trim() == 'completed';
  }

  static Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return {};
  }

  static String _uiStatus(String value) {
    final status = value.toLowerCase().trim();

    if (status == 'pending') return 'Pending';
    if (status == 'active' || status == 'current') return 'In progress';
    if (status == 'completed') return 'Completed';
    if (status == 'rejected' || status == 'cancelled') return 'Rejected';

    return value;
  }

  DriverBookingTaskModel copyWith({
    String? id,
    String? carId,
    String? driverName,
    String? driverImage,
    String? customerName,
    String? customerPhone,
    String? carName,
    String? carImage,
    String? plateNumber,
    String? vin,
    String? pickupLocation,
    String? bookingDate,
    String? endDate,
    String? createdAt,
    String? price,
    String? status,
    double? customerRating,
    int? tripRating,
    DateTime? completedAt,
    String? licenseTitle,
    String? licenseNumber,
    String? licenseExpiry,
    String? licenseImage,
    bool? licenseVerified,
  }) {
    return DriverBookingTaskModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      driverName: driverName ?? this.driverName,
      driverImage: driverImage ?? this.driverImage,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      carName: carName ?? this.carName,
      carImage: carImage ?? this.carImage,
      plateNumber: plateNumber ?? this.plateNumber,
      vin: vin ?? this.vin,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      bookingDate: bookingDate ?? this.bookingDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
      status: status ?? this.status,
      customerRating: customerRating ?? this.customerRating,
      tripRating: tripRating ?? this.tripRating,
      completedAt: completedAt ?? this.completedAt,
      licenseTitle: licenseTitle ?? this.licenseTitle,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      licenseImage: licenseImage ?? this.licenseImage,
      licenseVerified: licenseVerified ?? this.licenseVerified,
    );
  }
}