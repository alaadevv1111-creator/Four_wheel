class GoogleAuthModel{
  final String token;

  GoogleAuthModel({
    required this.token,
});
  Map<String, dynamic> toJson(){
    return {
      "token" : token
    };
  }
}