class ResetPasswordModel {
  final String email;
  final String code;
  final String password;
  final String passwordConfirmation;

  ResetPasswordModel({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "code": code,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}