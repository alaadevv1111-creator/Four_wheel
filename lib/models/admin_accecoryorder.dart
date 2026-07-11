class AdminAccessoryOrderModel {
  final String id;
  final String accessoryId;
  final String? bookingId;
  final int quantity;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String notes;
  final String userId;
  final String totalPrice;

  // بيانات القطعة (لو موجودة متداخلة بالـ response)
  final String accessoryName;
  final String accessoryImage;

  AdminAccessoryOrderModel({
    required this.id,
    required this.accessoryId,
    this.bookingId,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.notes,
    required this.userId,
    required this.totalPrice,
    required this.accessoryName,
    required this.accessoryImage,
  });

  factory AdminAccessoryOrderModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? accessoryMap;
    if (json['accessory'] is Map<String, dynamic>) {
      accessoryMap = json['accessory'];
    }

    final accId = json['accessory_id']?.toString() ?? '';

    return AdminAccessoryOrderModel(
      id: json['id']?.toString() ?? '',
      accessoryId: accId,
      bookingId: json['booking_id']?.toString(),
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      totalPrice: json['total_price']?.toString() ?? '0',
      accessoryName: accessoryMap?['name']?.toString() ?? 'Accessory #$accId',
      accessoryImage: accessoryMap?['photo']?.toString() ?? '', // مسار خام بس، بدون base URL
    );
  }

  AdminAccessoryOrderModel copyWith({String? status}) {
    return AdminAccessoryOrderModel(
      id: id,
      accessoryId: accessoryId,
      bookingId: bookingId,
      quantity: quantity,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      fullName: fullName,
      phone: phone,
      address: address,
      city: city,
      notes: notes,
      userId: userId,
      totalPrice: totalPrice,
      accessoryName: accessoryName,
      accessoryImage: accessoryImage,
    );
  }
}