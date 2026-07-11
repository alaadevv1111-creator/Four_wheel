class ProfileModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? image;

  ProfileModel({
    this.name,
    this.email,
    this.phone,
    this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone']?.toString(),
      image: json['image_url'] ?? json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
    };
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? image,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }
}