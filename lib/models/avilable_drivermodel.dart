/// Model for a driver returned by GET /user/booking-setup (field
/// "available_drivers"). This is the ONLY correct shape — confirmed from
/// the Postman response: { id, name, evaluation, total_trips, image }.
///
/// NOTE: an older version of this model used `experience` / `rating`
/// fields that do not exist anywhere in the real API response. That
/// version has been removed — do not recreate it, it will silently break
/// every screen that shows the driver list.
class AvailableDriverModel {
  final String id;
  final String name;
  final double evaluation;
  final int totalTrips;
  final String image;

  AvailableDriverModel({
    required this.id,
    required this.name,
    this.evaluation = 0,
    this.totalTrips = 0,
    this.image = '',
  });

  factory AvailableDriverModel.fromJson(Map<String, dynamic> json) {
    return AvailableDriverModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      evaluation: double.tryParse(json['evaluation']?.toString() ?? '') ?? 0,
      totalTrips: int.tryParse(json['total_trips']?.toString() ?? '') ?? 0,
      image: json['image']?.toString() ?? '',
    );
  }
}