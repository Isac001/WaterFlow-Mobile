import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:waterflow_mobile/modules/auth/controllers/auth_controller.dart';

class DioConfig {
  // Importando o controlador de usuário
  final AuthController _authController = Get.find<AuthController>();

  // Instanciando o dio em uma variavel privada
  final Dio _dio;

  // Getter para acessar o dio
  get dio => _dio;

  // Configurando o dio
  DioConfig()
      : _dio = Dio(
          BaseOptions(
            baseUrl: const String.fromEnvironment('BASEURL',
                defaultValue: 'http://localhost:8000/'),
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
          ),
        ) {
    // Adiciona o interceptador // tarta o que sai e entra do app entre a api e a internet
    _dio.interceptors.add(
      InterceptorsWrapper(
        // Tratamento da requisição a ser enviada
        onRequest: (options, handler) {
          // Obtém o token do controlador
          final token = _authController.token.value;

          // Verifica se esta preenchido
          if (token.isNotEmpty) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
          }

          // Define conteúdo padrão
          options.headers[HttpHeaders.contentTypeHeader] = 'aplication/json';

          // Faz a requisição continuar
          return handler.next(options);
        },

        // Tratamento da resposta do servidor
        onResponse: (response, handle) {
          // Depuração
          log('Response from: ${response.requestOptions.path} | Status: ${response.statusCode}');

          // Faz com que a resposta continue
          return handle.next(response);
        },

        // Tratamento de erro
        onError: (DioException error, handler) {
          log('Error on ${error.requestOptions.path} | Status: ${error.response?.statusCode}',
              error: error);

          // Permite que o erro continue para ser captado por um catch
          return handler.next(error);
        },
      ),
    );
  }
}
