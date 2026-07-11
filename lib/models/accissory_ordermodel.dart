class AccessoryOrderModel {
  final String id;
  final String orderNumber;
  final String image;
  final String accessoryName;
  final String orderDate;
  final String price;
  final String status;

  final String category;
  final String orderId;
  final String quantity;
  final String unitPrice;
  final String paymentMethod;
  final String paymentStatus;

  AccessoryOrderModel({
    required this.id,
    required this.orderNumber,
    required this.image,
    required this.accessoryName,
    required this.orderDate,
    required this.price,
    required this.status,
    this.category = 'Exterior Accessories',
    this.orderId = '#ORD-4492',
    this.quantity = 'x2',
    this.unitPrice = '\$249',
    this.paymentMethod = 'Cash On Delivery',
    this.paymentStatus = 'PENDING PAYMENT',
  });
  AccessoryOrderModel copyWith({
    String? id,
    String? orderNumber,
    String? image,
    String? accessoryName,
    String? orderDate,
    String? price,
    String? status,
    String? category,
    String? orderId,
    String? quantity,
    String? unitPrice,
    String? paymentMethod,
    String? paymentStatus,
  }) {
    return AccessoryOrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      image: image ?? this.image,
      accessoryName: accessoryName ?? this.accessoryName,
      orderDate: orderDate ?? this.orderDate,
      price: price ?? this.price,
      status: status ?? this.status,
      category: category ?? this.category,
      orderId: orderId ?? this.orderId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}