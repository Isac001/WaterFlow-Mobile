import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:waterflow_mobile/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/controllers/general_controller.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

class DioConfig {
  // Instantiating the necessary controllers
  final AuthController _authController = getx.Get.find<AuthController>();

  final GeneralController _generalController =
      getx.Get.find<GeneralController>();

  // Instantiating Dio and setting a getter for it
  final Dio _dio;
  get dio => _dio;

  // Show Loading variable
  bool showLoading;

  // Class constructor
  DioConfig({this.showLoading = true}) : _dio = Dio() {
    // Adding the interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        // Called before the request is sent for processing
        onRequest: (options, handler) {
          // Checks if the request should skip showing the loading indicator
          if (options.extra['skipLoading'] != true) {
            // Calls generalController which controls how many active requests are happening
            if (_generalController.loadingIndex.value == 0) {
              // Shows loading popup
              getx.Get.dialog(
                  const PopScope(
                    canPop: false,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: ThemeColor.greyColor),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  barrierColor: ThemeColor.greyColor,
                  barrierDismissible: false);
            }
            // Increments the active requests counter
            _generalController.loadingIndex.value++;
          }

          // Adds the authentication token to the header of all requests
          options.headers[HttpHeaders.authorizationHeader] =
              'Bearer ${_authController.token.value}';

          // Defines the default content type (json)
          options.headers[HttpHeaders.contentTypeHeader] = 'application/json';

          // Network response timeout
          options.connectTimeout = const Duration(milliseconds: 30000);
          options.receiveTimeout = const Duration(milliseconds: 30000);

          // Continues the request flow
          return handler.next(options);
        },

        // Handling when a request is successfully received
        onResponse: (response, handler) {
          log('${response.requestOptions.path} returned ${response.data}',
              name: 'Request Response');

          // If it didn't skip loading
          if (response.requestOptions.extra['skipLoading'] != true) {
            _generalController.loadingIndex.value -= 1;

            if (_generalController.loadingIndex.value == 0) {
              getx.Get.until((route) => !getx.Get.isDialogOpen!);
            }
          }
          return handler.next(response);
        },
        // Handling when an error occurs during the request
        onError: (error, handle) {
          // If the error is a DioException, it means there was an issue with the request
          if (error.requestOptions.extra['skipLoading'] != true) {
            _generalController.loadingIndex.value -= 1;
          }

          // If the loading index is 0, it means there are no active requests
          if (_generalController.loadingIndex.value == 0) {
            if (error.requestOptions.method == 'GET') {
              getx.Get.back(closeOverlays: true);
            } else {
              getx.Get.until((route) => !getx.Get.isDialogOpen!);
            }
          }

          // If the error is a DioException, it means there was an issue with the request
          log(
            '${error.requestOptions.path} retornou ${error.response?.statusCode}',
            name: 'Erro na requisição',
          );

          // If the error is a DioException, it means there was an issue with the request
          _showExceptipn(error.response?.data ?? error.message);

          // If the error is a DioException, it means there was an issue with the request
          return handle.next(error);
        },
      ),
    );
  }

// Function to show an exception
  void _showExceptipn(dynamic data) {
    // Case 1: If the data is a Map, it means it's an error response from the server
    if (data is String) {
      _generalController.errorSnackBarCustom(message: data);
    }

    // Case 2: the field 'data' is a List, which means it contains multiple error messages
    else if (data is List<dynamic>) {
      _generalController.errorSnackBarCustom(message: data.first);
    }

    // Case 3: If the data is a Map, it means it contains a single error message
    else if (data is Map<String, dynamic>) {
      data.forEach(
        (key, value) {
          if (value is List) {
            for (var element in value) {
              _generalController.errorSnackBarCustom(message: '$key: $element');
            }
          }
          // Case 4: If the data is a String, it means it's a single error message
          else {
            _generalController.errorSnackBarCustom(message: data.toString());
          }
        },
      );
    }
    // Case 5: If the data is null, it means the service is unavailable
    else {
      _generalController.errorSnackBarCustom(
          message: 'Serviço indisponível, tente mais tarde.');
    }
  }
}
