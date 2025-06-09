class AuthModel {
  String? userEmail;
  String? password;

  AuthModel({this.userEmail, this.password});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        userEmail: json['user_email'].toString(), password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'user_email': userEmail, 'password': password};
  }
}
