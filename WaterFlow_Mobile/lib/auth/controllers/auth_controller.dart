import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:waterflow_mobile/auth/services/auth_service.dart';
import 'package:waterflow_mobile/project_configs/local_secure_data_config.dart';

class AuthController extends GetxController {
  
  // Variables that store the token and logged-in user ID
  RxString token = "".obs;
  RxString refreshToken = "".obs;
  RxInt idUserLogged = 0.obs;

  // method to clear the variables
  cleanVariables() {
    token.value = "";
    idUserLogged.value = 0;
  }

  // function to wait for the token call
  Future<void> waitForToken() async {
    while (token.value.isEmpty) {
      await Future.delayed(const Duration(microseconds: 100));
    }
  }

  // Function to decode the token in the response
  Map<String, dynamic> tokenDecoder(dynamic response) {

    // Save the token and refresh token in the variables
    token.value = response['access'];
    refreshToken.value = response['refresh'];

    // Decode the token to get the user ID
    Map<String, dynamic> tokenDecoer = JwtDecoder.decode(token.value);

    // Save the user ID in the variable
    idUserLogged.value = tokenDecoer['user_id'];

    // Save the token and refresh token in secure storage
    Map<String, dynamic> tokenDecoder = JwtDecoder.decode(token.value);

    // Navigate to the home screen if the token is not empty
    if (token.isNotEmpty) {
      Get.offNamed('/home');
    }

    // Return the decoded token
    return tokenDecoder;
  }

  // Logout method
  Future<void> logout() async {
    AuthService().logout().then((value) {

      // Clear the variables
      token.value = "";

      refreshToken.value = "";

      idUserLogged.value = 0;

      // Clear the secure data
      LocalSecureData.deleteSecureData();
    });
  }
}
