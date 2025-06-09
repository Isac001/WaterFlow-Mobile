import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/modules/auth/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:waterflow_mobile/utils/dio_config.dart';

// Classe principal
class AuthService {
  // Mapeamento da URL do servidor
  final String baseUrl = const String.fromEnvironment('BASEURL');

  // Mapeamento do endpoint do token
  final String tokenEndpoint = 'token/';

  // Mapeamento do endpoint de logout
  final String lougoutEndpoint = 'logout/';

  // Controlador de autenticação
  final AuthController _authController = Get.find<AuthController>();

  // Importação do Dio personalizado
  final Dio _dio = DioConfig().dio;

  // Metodo para a autenticação
  Future<void> requestToken({required AuthModel authModel}) async {
    // Try e Catch para tartamento de erros
    try {
      // Mapeia a URL completa para o token e com os dados de autenticação
      dynamic response =
          await _dio.post('$baseUrl$tokenEndpoint', data: authModel.toJson());

      // Tratamento de sucesso da requisição
      if (response.statusCode == 200) {
        _authController.tokenDecoder(response.data);
        return response.data;

        // Tratamento de erro
      } else {
        return Future.error(response.data);
      }

      // Captura de execção a nível do dio
    } on DioException catch (error) {
      if (error.response != null) {
        return Future.error(error.response!.data);
      } else {
        return Future.error(error);
      }
    }
  }

  // Metodo para logout
  Future logout() async {
    try {
      // URL completa para logout
      dynamic response = await _dio.post(
        '$baseUrl$lougoutEndpoint',
      );

      // Tratamento de requisição bem sucedida
      if (response.statusCode == 205) {
        return response.data;
      } else {
        return Future.error(response.data);
      }

      // Tratamento de erro
    } on DioException catch (error) {
      if (error.response != null) {
        return Future.error(error.response!.data);
      } else {
        return Future.error(error);
      }
    }
  }
}
