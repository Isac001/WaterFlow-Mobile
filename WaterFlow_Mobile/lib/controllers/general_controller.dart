import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

/// GeneralController is a GetX controller that manages general application state
/// and provides utility methods for displaying error messages.
class GeneralController extends GetxController {

  // Variable to control the number of active requests
  final loadingIndex = 0.obs;

  // Method to return a request error snackbar
  void errorSnackBarCustom({required String message}) {
    Get.snackbar(
      'ERROR',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: ThemeColor.redAccent,
      colorText: ThemeColor.whiteColor,
      margin: const EdgeInsets.all(kPaddingSmall),
      borderRadius: kRadiusSmall
    );
  }
}
