class ServiceOrderModel {
  final String id;
  final String requestNumber;
  final String serviceName;
  final String date;
  final String time;
  final String location;
  final String status;

  final String problemDescription;
  final String vehicleModel;
  final String mechanicName;
  final String mechanicImage;
  final String mechanicInfo;

  ServiceOrderModel({
    required this.id,
    required this.requestNumber,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    this.problemDescription = '',
    this.vehicleModel = '',
    this.mechanicName = '',
    this.mechanicImage = '',
    this.mechanicInfo = '',
  });
  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    final mechanic = json['mechanic'];

    Map<String, dynamic> mechanicMap = {};
    if (mechanic is Map<String, dynamic>) {
      mechanicMap = mechanic;
    }

    final scheduledAt = json['scheduled_at']?.toString() ?? '';
    final parsedDate = DateTime.tryParse(scheduledAt);

    return ServiceOrderModel(
      id: json['id']?.toString() ?? '',
      requestNumber: '#SRV-${json['id']?.toString() ?? ''}',
      serviceName: json['service_type']?.toString() ??
          json['service_name']?.toString() ??
          'Service Request',
      date: parsedDate == null
          ? scheduledAt
          : '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}',
      time: parsedDate == null
          ? ''
          : '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}',
      location: json['location']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      problemDescription: json['problem_description']?.toString() ??
          json['reported_issue']?.toString() ??
          '',
      vehicleModel: json['vehicle_model']?.toString() ?? 'Not Specified',
      mechanicName: mechanicMap['name']?.toString() ?? '',
      mechanicImage: mechanicMap['image']?.toString() ??
          mechanicMap['image_url']?.toString() ??
          '',
      mechanicInfo: mechanicMap['phone_number']?.toString() ??
          mechanicMap['phone']?.toString() ??
          mechanicMap['email']?.toString() ??
          '',
    );
  }
  ServiceOrderModel copyWith({
    String? id,
    String? requestNumber,
    String? serviceName,
    String? date,
    String? time,
    String? location,
    String? status,
    String? problemDescription,
    String? vehicleModel,
    String? mechanicName,
    String? mechanicImage,
    String? mechanicInfo,
  }) {
    return ServiceOrderModel(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      serviceName: serviceName ?? this.serviceName,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      status: status ?? this.status,
      problemDescription: problemDescription ?? this.problemDescription,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      mechanicName: mechanicName ?? this.mechanicName,
      mechanicImage: mechanicImage ?? this.mechanicImage,
      mechanicInfo: mechanicInfo ?? this.mechanicInfo,
    );
  }
}