class UserOrderModel {
  final String id;
  final String category;
  final String status;

  final String carImage;
  final String carName;
  final String rentalId;
  final String totalPrice;

  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;
  final String location;
  final String duration;

  UserOrderModel({
    required this.id,
    required this.category,
    required this.status,
    required this.carImage,
    required this.carName,
    required this.rentalId,
    required this.totalPrice,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    this.location = '',
    this.duration = '',
  });

  UserOrderModel copyWith({
    String? id,
    String? category,
    String? status,
    String? carImage,
    String? carName,
    String? rentalId,
    String? totalPrice,
    String? pickupDate,
    String? pickupTime,
    String? returnDate,
    String? returnTime,
    String? location,
    String? duration,
  }) {
    return UserOrderModel(
      id: id ?? this.id,
      category: category ?? this.category,
      status: status ?? this.status,
      carImage: carImage ?? this.carImage,
      carName: carName ?? this.carName,
      rentalId: rentalId ?? this.rentalId,
      totalPrice: totalPrice ?? this.totalPrice,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      returnDate: returnDate ?? this.returnDate,
      returnTime: returnTime ?? this.returnTime,
      location: location ?? this.location,
      duration: duration ?? this.duration,
    );
  }
}