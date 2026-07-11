class ServiceRequestModel {
  final String id;
  final String userId;
  final String mechanicId;

  final String name;
  final String phone;

  final String serviceName;
  final String serviceType;

  final String description;
  final String problemDescription;

  final String vehicleModel;
  final String status;

  final String scheduledAt;
  final String date;
  final String time;

  final String location;

  final String customerName;
  final String customerEmail;
  final String customerPhone;

  final String mechanicName;
  final String mechanicImage;
  final double mechanicEvaluation;

  ServiceRequestModel({
    required this.id,
    this.userId = '',
    this.mechanicId = '',
    this.name = '',
    this.phone = '',
    this.serviceName = '',
    this.serviceType = '',
    this.description = '',
    this.problemDescription = '',
    this.vehicleModel = '',
    this.status = 'pending',
    this.scheduledAt = '',
    this.date = '',
    this.time = '',
    this.location = '',
    this.customerName = '',
    this.customerEmail = '',
    this.customerPhone = '',
    this.mechanicName = '',
    this.mechanicImage = '',
    this.mechanicEvaluation = 0,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final mechanic = json['mechanic'];

    Map<String, dynamic> userMap = {};
    if (user is Map<String, dynamic>) {
      userMap = user;
    }

    Map<String, dynamic> mechanicMap = {};
    if (mechanic is Map<String, dynamic>) {
      mechanicMap = mechanic;
    }

    Map<String, dynamic> mechanicUserMap = {};
    if (mechanicMap['user'] is Map<String, dynamic>) {
      mechanicUserMap = mechanicMap['user'];
    }

    final scheduled = json['scheduled_at']?.toString() ??
        json['preferred_date']?.toString() ??
        '';

    String extractedDate = '';
    String extractedTime = '';

    final parsedDate = DateTime.tryParse(scheduled);

    if (parsedDate != null) {
      extractedDate =
      '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
      extractedTime =
      '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } else if (scheduled.isNotEmpty) {
      extractedDate = scheduled.split(' ').first.split('T').first;

      if (scheduled.contains(' ')) {
        final parts = scheduled.split(' ');
        if (parts.length > 1 && parts[1].length >= 5) {
          extractedTime = parts[1].substring(0, 5);
        }
      }
    }

    if (extractedTime.isEmpty) {
      extractedTime = json['preferred_time']?.toString() ?? '';
    }

    final requestName = json['name']?.toString() ??
        userMap['name']?.toString() ??
        userMap['full_name']?.toString() ??
        '';

    final requestPhone = json['phone']?.toString() ??
        json['phone_number']?.toString() ??
        userMap['phone_number']?.toString() ??
        userMap['phone']?.toString() ??
        '';

    final mechanicNameValue = mechanicUserMap['name']?.toString() ??
        mechanicMap['name']?.toString() ??
        '';

    final mechanicImageValue = mechanicUserMap['image']?.toString() ??
        mechanicUserMap['image_url']?.toString() ??
        mechanicMap['image']?.toString() ??
        mechanicMap['image_url']?.toString() ??
        '';

    final mechanicEvaluationValue = double.tryParse(
      mechanicMap['evaluation']?.toString() ??
          mechanicMap['rating']?.toString() ??
          mechanicUserMap['rating']?.toString() ??
          '0',
    ) ??
        0;

    return ServiceRequestModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      mechanicId: json['mechanic_id']?.toString() ?? '',

      name: requestName,
      phone: requestPhone,

      serviceName: json['service_type']?.toString() ??
          json['service_name']?.toString() ??
          'General Maintenance',

      serviceType: json['service_type']?.toString() ??
          json['service_name']?.toString() ??
          'General Maintenance',

      description: json['problem_description']?.toString() ??
          json['description']?.toString() ??
          '',

      problemDescription: json['problem_description']?.toString() ??
          json['description']?.toString() ??
          '',

      vehicleModel: json['vehicle_model']?.toString() ?? 'Not Specified',

      status: json['status']?.toString() ?? 'pending',

      scheduledAt: scheduled,
      date: extractedDate,
      time: extractedTime,

      location: json['location']?.toString() ?? '',

      customerName: requestName,
      customerEmail: userMap['email']?.toString() ??
          json['email']?.toString() ??
          '',
      customerPhone: requestPhone,

      mechanicName: mechanicNameValue,
      mechanicImage: mechanicImageValue,
      mechanicEvaluation: mechanicEvaluationValue,
    );
  }

  String get requestNumber {
    return '#SRV-$id';
  }

  int get apiId {
    return int.tryParse(id) ?? 0;
  }

  bool get isPending {
    return status.toLowerCase().trim() == 'pending';
  }

  bool get isActive {
    final s = status.toLowerCase().trim();
    return s == 'active' || s == 'inprogress' || s == 'in_progress';
  }

  bool get isCompleted {
    return status.toLowerCase().trim() == 'completed';
  }

  String get reportedIssue {
    if (problemDescription.isNotEmpty) return problemDescription;
    if (description.isNotEmpty) return description;
    return 'No issue description';
  }

  String get technicianName {
    if (mechanicName.isNotEmpty) return mechanicName;
    return 'Not assigned yet';
  }

  String get technicianImage {
    return mechanicImage;
  }

  String get technicianRating {
    return mechanicEvaluation.toStringAsFixed(1);
  }

  String get technicianServices {
    if (mechanicName.isEmpty) return 'No services yet';
    return 'Assigned Mechanic';
  }

  String get technicianExperience {
    if (mechanicName.isEmpty) return 'Pending assignment';
    return 'Expert technician';
  }

  ServiceRequestModel copyWith({
    String? id,
    String? userId,
    String? mechanicId,
    String? name,
    String? phone,
    String? serviceName,
    String? serviceType,
    String? description,
    String? problemDescription,
    String? vehicleModel,
    String? status,
    String? scheduledAt,
    String? date,
    String? time,
    String? location,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? mechanicName,
    String? mechanicImage,
    double? mechanicEvaluation,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mechanicId: mechanicId ?? this.mechanicId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      serviceName: serviceName ?? this.serviceName,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      problemDescription: problemDescription ?? this.problemDescription,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      mechanicName: mechanicName ?? this.mechanicName,
      mechanicImage: mechanicImage ?? this.mechanicImage,
      mechanicEvaluation: mechanicEvaluation ?? this.mechanicEvaluation,
    );
  }
}