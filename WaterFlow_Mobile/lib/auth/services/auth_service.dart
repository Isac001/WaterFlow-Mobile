import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/auth/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:waterflow_mobile/project_configs/dio_config.dart';

// Main class
class AuthService {
  // Server URL mapping
  final String baseUrl = const String.fromEnvironment('BASEURL');

  // Token endpoint mapping
  final String tokenEndpoint = 'token-auth/';

  // Logout endpoint mapping
  final String lougoutEndpoint = 'logout/';

  // Authentication controller
  final AuthController _authController = Get.find<AuthController>();

  // Custom Dio import
  final Dio _dio = DioConfig().dio;

  // Method for authentication
  Future<void> requestToken({required AuthModel authModel}) async {
    // Try and Catch for error handling

    try {
      // Maps the full URL for the token with the authentication data
      dynamic response =
          await _dio.post('$baseUrl$tokenEndpoint', data: authModel.toJson());

      // Request success handling
      if (response.statusCode == 200) {
        _authController.tokenDecoder(response.data);
        return response.data;

        // Error handling
      } else {
        return Future.error(response.data);
      }

      // Dio-level exception capture
    } on DioException catch (error) {
      if (error.response != null) {
        return Future.error(error.response!.data);
      } else {
        return Future.error(error);
      }
    }
  }

  // Method for logout
  Future logout() async {
    try {
      // Full URL for logout
      dynamic response = await _dio.post(
        '$baseUrl$lougoutEndpoint',
      );

      // Successful request handling
      if (response.statusCode == 205) {
        return response.data;
      } else {
        return Future.error(response.data);
      }

      // Error handling
    } on DioException catch (error) {
      if (error.response != null) {
        return Future.error(error.response!.data);
      } else {
        return Future.error(error);
      }
    }
  }
}
