class EmployeeModel {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String status;
  final String email;
  final String imageUrl;
  final String drivingLicensePath;
  final bool hasLicense;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.status,
    required this.imageUrl,
    required this.email,
    this.drivingLicensePath = '',
    required this.hasLicense,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone_number']?.toString() ??
          json['phone']?.toString() ??
          '',
      status: json['status']?.toString() ?? 'inactive',
      imageUrl: json['image_url']?.toString() ??
          json['image']?.toString() ??
          '',
      email: json['email']?.toString() ?? '',

      // has_license ممكن ييجي بالمستوى الأعلى، أو نستنتجه من وجود driver.driving_license
      hasLicense: json['has_license'] == true ||
          json['has_license'] == 1 ||
          _extractLicensePath(json).isNotEmpty,

      drivingLicensePath: _extractLicensePath(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
      'status': status,
      'image_url': imageUrl,
      'email': email,
      'driving_license': drivingLicensePath,
    };
  }

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? status,
    String? imageUrl,
    String? email,
    String? drivingLicensePath,
    bool? hasLicense,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      drivingLicensePath: drivingLicensePath ?? this.drivingLicensePath,
      hasLicense: hasLicense ?? this.hasLicense,
    );
  }

  static String _extractLicensePath(Map<String, dynamic> json) {
    // 1) جرب الحقول المباشرة بمستوى الـ root
    final direct = json['driving_license'] ??
        json['driving_license_image'] ??
        json['driving_license_path'] ??
        json['driving_license_url'] ??
        json['license_image'] ??
        json['license_image_url'] ??
        json['license_path'];

    final String fromDirect = _valueToPath(direct);
    if (fromDirect.isNotEmpty) {
      return fromDirect;
    }

    // 2) جرب جوا كائن driver المتداخل
    // "driver": { "driving_license": "licenses/xxxx.jpg", ... }
    final driverObj = json['driver'];
    if (driverObj is Map<String, dynamic>) {
      final fromDriver = driverObj['driving_license'] ??
          driverObj['driving_license_image'] ??
          driverObj['driving_license_path'] ??
          driverObj['license_image'] ??
          driverObj['license_path'];

      final String fromDriverPath = _valueToPath(fromDriver);
      if (fromDriverPath.isNotEmpty) {
        return fromDriverPath;
      }
    }

    // 3) جرب جوا كائن employee المتداخل (احتياط لو تغيّر شكل الريسبونس)
    final employeeObj = json['employee'];
    if (employeeObj is Map<String, dynamic>) {
      final fromEmployee = employeeObj['driving_license'] ??
          employeeObj['license_image'] ??
          employeeObj['license_path'];

      final String fromEmployeePath = _valueToPath(fromEmployee);
      if (fromEmployeePath.isNotEmpty) {
        return fromEmployeePath;
      }
    }

    return '';
  }

  static String _valueToPath(dynamic value) {
    if (value == null) return '';

    if (value is String) {
      return value.trim();
    }

    if (value is Map<String, dynamic>) {
      return value['path']?.toString() ??
          value['url']?.toString() ??
          value['image']?.toString() ??
          value['file']?.toString() ??
          '';
    }

    return '';
  }
}