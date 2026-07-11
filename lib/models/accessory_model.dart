class AccessoryModel {
  final int? id;
  final String name;
  final String category;
  final String? status;
  final double price;
  final int stockQuantity;
  final int? unitId;
  final String? unitName;
  final String? partId;
  final String? photoUrl;
  final String? updatedAt;
  final double? assetValue;
  final double averageRating; // المتغير الجديد

  AccessoryModel({
    this.id,
    required this.name,
    required this.category,
    this.status,
    required this.price,
    required this.stockQuantity,
    this.unitId,
    this.unitName,
    this.partId,
    this.photoUrl,
    this.updatedAt,
    this.assetValue,
    this.averageRating = 0.0,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    // Handling nested unit object or simple string/int
    int? uId;
    String? uName;
    if (json['unit'] != null) {
      if (json['unit'] is Map) {
        uId = json['unit']['id'];
        uName = json['unit']['name']?.toString();
      } else {
        uName = json['unit'].toString();
      }
    }

    // تنسيق رابط الصورة ليحتوي على المسار الكامل تلقائياً
    String? rawPhoto = json['photo_url'] ?? json['imageUrl'] ?? json['photo'];
    String? formattedPhoto;
    if (rawPhoto != null && rawPhoto.isNotEmpty) {
      if (rawPhoto.startsWith('http')) {
        formattedPhoto = rawPhoto;
      } else {
        String cleanPath = rawPhoto.startsWith('/') ? rawPhoto.substring(1) : rawPhoto;
        formattedPhoto = "http://reload-hug-monastery.ngrok-free.dev/storage/$cleanPath";
      }
    }

    return AccessoryModel(
      id: json['id'],
      name: json['name'] ?? json['item_name'] ?? json['itemName'] ?? '',
      category: json['category'] ?? '',
      status: json['status'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stock_quantity'] ?? json['quantity'] ?? 0,
      unitId: uId ?? json['unit_id'],
      unitName: uName,
      partId: json['part_id'] ?? json['sku'],
      photoUrl: formattedPhoto,
      updatedAt: json['updated_at'] ?? json['last_modified'],
      assetValue: (json['asset_value'] as num?)?.toDouble(),
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'status': status,
      'price': price,
      'stock_quantity': stockQuantity,
      'unit_id': unitId,
      'part_id': partId,
      'photo_url': photoUrl,
      'updated_at': updatedAt,
      'asset_value': assetValue,
    };
  }
}
