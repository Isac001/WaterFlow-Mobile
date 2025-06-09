import 'package:get/state_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:waterflow_mobile/modules/auth/services/auth_service.dart';
import 'package:waterflow_mobile/utils/local_secure_data_config.dart';

class AuthController extends GetxController {
  // Variaveis que armazenam o token e id do usuário
  RxString token = "".obs;
  RxInt idUserLogged = 0.obs;

  // metodo para limpar as variaveis
  cleanVariables() {
    token.value = "";
    idUserLogged.value = 0;
  }

  // função para esperar a chamada do token
  Future<void> waitForToken() async {
    while (token.value.isEmpty) {
      await Future.delayed(const Duration(microseconds: 100));
    }
  }

  // Função para decodificaar o token na resposta
  Map<String, dynamic> tokenDecoder(dynamic response) {
    token.value = response['access'];

    Map<String, dynamic> tokenDecoder = JwtDecoder.decode(token.value);

    return tokenDecoder;
  }

  // Metodo de logout
  Future<void> logout() async {
    AuthService().logout().then((value) {
      token.value = "";

      idUserLogged.value = 0;

      LocalSecureData.deleteSecureData();

    });
  }
}
