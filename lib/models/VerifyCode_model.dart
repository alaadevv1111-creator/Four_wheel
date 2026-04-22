class VerifyCodeModel {
  final String email;
  final String code;



  VerifyCodeModel({
    required this.email,
    required this.code,

  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "code": code
    };
  }
}