import 'dart:developer';

// Class representing the authentication model
class AuthModel {

  // Fields for user email and password
  String? userEmail;
  String? password;

  // Constructor for the AuthModel class
  AuthModel({this.userEmail, this.password});

  // Factory constructor to create an AuthModel instance from JSON
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        userEmail: json['user_email'].toString(), password: json['password']);
  }

  // Method to convert the AuthModel instance to JSON
  Map<String, dynamic> toJson() {
    log("$this.userEmail");
    return {'user_email': userEmail, 'password': password};
  }
}
