import 'package:four_wheels/widgets/Custom_CarCard.dart';

class CarModel {
  final String id;
  final String model;
  final String brand;
  final String year;
  final String licensePlate;
  final CarStatus status;
  final String dailyPrice;
  final String imageUrl;

  CarModel({
    required this.id,
    required this.model,
    required this.brand,
    required this.year,
    required this.licensePlate,
    required this.status,
    required this.dailyPrice,
    required this.imageUrl,
  });

  // ============================================================
  // موسّعة لتتحمل كل الصيغ المحتملة يلي ممكن الباك إند يرجعها
  // للحالة "مؤجرة" أو "تحت الصيانة"، بدل ما تفترض إنه أي قيمة
  // غير "available"/"rented"/"maintenance" بالحرف = Available.
  // هاد بالضبط كان سبب إنه السيارة تضل "Available" حتى لو
  // انعمل عليها بوكينج فعلي وصار وضعها مختلف بالباك إند.
  // ============================================================
  static CarStatus statusFromJson(dynamic value) {
    final status = value?.toString().toLowerCase().trim() ?? '';

    const rentedValues = {
      'rented',
      'reserved',
      'booked',
      'in_use',
      'in use',
      'unavailable',
      'active',
      'occupied',
      'not_available',
      'not available',
      'busy',
    };

    const maintenanceValues = {
      'maintenance',
      'in_maintenance',
      'under_maintenance',
      'under maintenance',
      'repair',
      'in_repair',
      'servicing',
    };

    if (status == 'available' || status == 'free' || status.isEmpty) {
      return CarStatus.available;
    }

    if (rentedValues.contains(status)) {
      return CarStatus.rented;
    }

    if (maintenanceValues.contains(status)) {
      return CarStatus.maintenance;
    }

    // احتياطي أخير: لو القيمة مش فاضية ومش "available" بأي صيغة معروفة،
    // الأصح إنها تتحسب "Rented" (مش Available) لأنه هاد أقرب للواقع -
    // سيارة معلّمة بأي حالة غير صريحة "متاحة" غالباً مش متاحة فعلياً.
    if (status.isNotEmpty) {
      return CarStatus.rented;
    }

    return CarStatus.available;
  }

  static String statusToApi(CarStatus status) {
    switch (status) {
      case CarStatus.available:
        return 'available';
      case CarStatus.rented:
        return 'rented';
      case CarStatus.maintenance:
        return 'maintenance';
    }
  }

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      licensePlate: json['plate_number']?.toString() ??
          json['license_plate']?.toString() ??
          '',
      status: statusFromJson(
        json['status'] ??
            json['car_status'] ??
            json['availability'] ??
            json['availability_status'],
      ),
      dailyPrice: json['price_per_day']?.toString() ??
          json['daily_price']?.toString() ??
          '',
      imageUrl: json['image_url']?.toString() ??
          json['image']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'brand': brand,
      'year': year,
      'plate_number': licensePlate,
      'status': statusToApi(status),
      'price_per_day': dailyPrice,
      'image_url': imageUrl,
    };
  }

  CarModel copyWith({
    String? id,
    String? model,
    String? brand,
    String? year,
    String? licensePlate,
    CarStatus? status,
    String? dailyPrice,
    String? imageUrl,
  }) {
    return CarModel(
      id: id ?? this.id,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      status: status ?? this.status,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}