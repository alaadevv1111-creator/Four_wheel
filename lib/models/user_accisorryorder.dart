class UserAccessoryOrderModel {
  final String id;
  final String accessoryId;
  final int quantity;
  final String status;
  final String createdAt;
  final String totalPrice;
  final String accessoryName;
  final String accessoryImage;

  UserAccessoryOrderModel({
    required this.id,
    required this.accessoryId,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.totalPrice,
    required this.accessoryName,
    required this.accessoryImage,
  });

  factory UserAccessoryOrderModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? accessoryMap;
    if (json['accessory'] is Map<String, dynamic>) {
      accessoryMap = json['accessory'];
    }

    final accId = json['accessory_id']?.toString() ?? '';

    final rawPhoto = accessoryMap?['photo']?.toString() ?? '';

    return UserAccessoryOrderModel(
      id: json['id']?.toString() ?? '',
      accessoryId: accId,
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      totalPrice: json['total_price']?.toString() ?? '0',
      accessoryName: accessoryMap?['name']?.toString() ?? 'Accessory #$accId',
      accessoryImage:rawPhoto,
    );
  }

  UserAccessoryOrderModel copyWith({String? status}) {
    return UserAccessoryOrderModel(
      id: id,
      accessoryId: accessoryId,
      quantity: quantity,
      status: status ?? this.status,
      createdAt: createdAt,
      totalPrice: totalPrice,
      accessoryName: accessoryName,
      accessoryImage: accessoryImage,
    );
  }
}

