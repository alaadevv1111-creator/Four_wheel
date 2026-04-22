class CheckEmailModel {
  final String email;

  CheckEmailModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}