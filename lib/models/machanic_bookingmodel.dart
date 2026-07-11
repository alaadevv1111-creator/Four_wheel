class MechanicMaintenanceTaskModel {
  final String id;
  final String customerName;
  final String customerPhone;

  final String carName;
  final String carImage;
  final String plateNumber;
  final String reportedIssue;
  final String requestDate;
  final String status;

  final String vin;
  final String customerImage;
  final String memberSince;

  MechanicMaintenanceTaskModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.carName,
    required this.carImage,
    required this.plateNumber,
    required this.reportedIssue,
    required this.requestDate,
    required this.status,
    this.vin = '',
    this.customerImage = '',
    this.memberSince = '',
  });

  MechanicMaintenanceTaskModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? carName,
    String? carImage,
    String? plateNumber,
    String? reportedIssue,
    String? requestDate,
    String? status,
    String? vin,
    String? customerImage,
    String? memberSince,
  }) {
    return MechanicMaintenanceTaskModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      carName: carName ?? this.carName,
      carImage: carImage ?? this.carImage,
      plateNumber: plateNumber ?? this.plateNumber,
      reportedIssue: reportedIssue ?? this.reportedIssue,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      vin: vin ?? this.vin,
      customerImage: customerImage ?? this.customerImage,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}