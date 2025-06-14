import 'package:get/state_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:waterflow_mobile/auth/services/auth_service.dart';
import 'package:waterflow_mobile/utils/project_configs/local_secure_data_config.dart';

class AuthController extends GetxController {
  // Variables that store the token and logged-in user ID
  RxString token = "".obs;
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
    token.value = response['access'];

    Map<String, dynamic> tokenDecoder = JwtDecoder.decode(token.value);

    return tokenDecoder;
  }

  // Logout method
  Future<void> logout() async {
    AuthService().logout().then((value) {
      token.value = "";

      idUserLogged.value = 0;

      LocalSecureData.deleteSecureData();

    });
  }
}
