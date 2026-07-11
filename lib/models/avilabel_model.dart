class AvailableMechanicModel {
  final int id;
  final String name;
  final String image;
  final double evaluation;

  AvailableMechanicModel({
    required this.id,
    required this.name,
    required this.image,
    required this.evaluation,
  });

  factory AvailableMechanicModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];

    Map<String, dynamic> userMap = {};
    if (user is Map<String, dynamic>) {
      userMap = user;
    } else if (user is Map) {
      userMap = Map<String, dynamic>.from(user);
    }

    return AvailableMechanicModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ??
          userMap['name']?.toString() ??
          'Mechanic',
      image: json['image']?.toString() ??
          json['image_url']?.toString() ??
          userMap['image']?.toString() ??
          userMap['image_url']?.toString() ??
          '',
      evaluation: double.tryParse(
        json['evaluation']?.toString() ??
            json['rating']?.toString() ??
            userMap['rating']?.toString() ??
            '0',
      ) ??
          0,
    );
  }
}