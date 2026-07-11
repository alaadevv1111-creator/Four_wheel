class MechanicJobModel {
  final String id;
  final String status;
  final String serviceType;
  final String problemDescription;
  final String vehicleModel;
  final String vehicleImage;
  final String location;
  final String scheduledAt;
  final String customerName;
  final String customerPhone;
  final String customerImage;
  final String price;
  final int? customerRating;


  MechanicJobModel({
    required this.id,
    required this.status,
    required this.serviceType,
    required this.problemDescription,
    required this.vehicleModel,
    required this.vehicleImage,
    required this.location,
    required this.scheduledAt,
    required this.customerName,
    required this.customerPhone,
    required this.customerImage,
    required this.price,
    required this.customerRating,

  });

  factory MechanicJobModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] ?? json['user'];

    Map<String, dynamic> customerMap = {};
    if (customer is Map<String, dynamic>) {
      customerMap = customer;
    }

    return MechanicJobModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      serviceType: json['service_type']?.toString() ?? 'Service Request',
      problemDescription: json['problem_description']?.toString() ?? '',
      vehicleModel: json['vehicle_model']?.toString() ?? 'Not Specified',
      vehicleImage: json['vehicle_image']?.toString() ??
          json['car_image']?.toString() ??
          json['image']?.toString() ??
          '',
      location: json['location']?.toString() ?? '',
      scheduledAt: json['scheduled_at']?.toString() ?? '',
      customerName: customerMap['name']?.toString() ??
          customerMap['full_name']?.toString() ??
          json['customer_name']?.toString() ??
          'Customer',
      customerPhone: customerMap['phone']?.toString() ??
          customerMap['phone_number']?.toString() ??
          json['customer_phone']?.toString() ??
          '',
      customerImage: customerMap['image']?.toString() ??
          customerMap['image_url']?.toString() ??
          json['customer_image']?.toString() ??
          '',
      price: json['price']?.toString() ??
          json['total_price']?.toString() ??
          '0',
      customerRating: int.tryParse(
        json['customer_rating']?.toString() ??
            json['rating']?.toString() ??
            json['mechanic_rating']?.toString() ??
            '',
      ),
    );
  }

  MechanicJobModel copyWith({
    String? id,
    String? status,
    String? serviceType,
    String? problemDescription,
    String? vehicleModel,
    String? vehicleImage,
    String? location,
    String? scheduledAt,
    String? customerName,
    String? customerPhone,
    String? customerImage,
    String? price,
    int? customerRating,
  }) {
    return MechanicJobModel(
      id: id ?? this.id,
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      problemDescription: problemDescription ?? this.problemDescription,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleImage: vehicleImage ?? this.vehicleImage,
      location: location ?? this.location,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerImage: customerImage ?? this.customerImage,
      price: price ?? this.price,
      customerRating: customerRating ?? this.customerRating,
    );
  }

  String get date {
    final parsed = DateTime.tryParse(scheduledAt);
    if (parsed == null) return scheduledAt.isEmpty ? '-' : scheduledAt;

    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }

  String get time {
    final parsed = DateTime.tryParse(scheduledAt);
    if (parsed == null) return '';

    return '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // مصحح: كانت 'active' موجودة بالاثنين (isPending و isInProgress
  // بتتناقض)، فكانت الحالة تضل Pending حتى بعد الضغط على Start
  // Repair (لأنه الباك إند بيرجع 'active' مش 'in_progress' حرفياً).
  // هلق 'active' بس بـ isInProgress، مش بـ isPending.
  // ============================================================
  bool get isPending {
    final value = status.toLowerCase().trim();

    return value == 'pending' || value == 'assigned' || value == 'active';
  }

  bool get isInProgress {
    final value = status.toLowerCase().trim();

    return value == 'in_progress' ||
        value == 'in progress' ||
        value == 'inprogress';
  }

  bool get isCompleted {
    return status.toLowerCase().trim() == 'completed';
  }

  String get displayStatus {
    if (isCompleted) return 'Completed';
    if (isInProgress) return 'In Progress';
    return 'Pending';
  }
}