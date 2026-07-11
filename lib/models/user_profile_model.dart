class UserProfileModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? phoneNumber;
  final String? image;
  final String? licenseNumber;
  final String? licenseImage;
  final double? rating;

  UserProfileModel({
    this.name,
    this.email,
    this.phone,
    this.phoneNumber,
    this.image,
    this.licenseNumber,
    this.licenseImage,
    this.rating,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    double? parsedRating;
    final ratingRaw = json['rating'] ?? json['stars'] ?? json['average_rating'];
    if (ratingRaw != null) {
      if (ratingRaw is num) {
        parsedRating = ratingRaw.toDouble();
      } else {
        parsedRating = double.tryParse(ratingRaw.toString());
      }
    }

    return UserProfileModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      phoneNumber: json['phone_number'],
      image: json['image'],
      licenseNumber: json['license_number'],
      licenseImage: json['license_image'],
      rating: parsedRating,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (image != null) data['image'] = image;
    if (licenseNumber != null) data['license_number'] = licenseNumber;
    if (licenseImage != null) data['license_image'] = licenseImage;
    if (rating != null) data['rating'] = rating;
    return data;
  }

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? phoneNumber,
    String? image,
    String? licenseNumber,
    String? licenseImage,
    double? rating,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseImage: licenseImage ?? this.licenseImage,
      rating: rating ?? this.rating,
    );
  }
}

class UpdatePasswordModel {
  final String oldPassword;
  final String password;
  final String passwordConfirmation;

  UpdatePasswordModel({
    required this.oldPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}