import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/models/auth_model.dart';
import 'package:waterflow_mobile/auth/services/auth_service.dart';
import 'package:waterflow_mobile/modules/login/keys/login_form_key.dart';
import 'package:waterflow_mobile/utils/project_configs/local_secure_data_config.dart';

// Main Class
class LoginScreenController extends GetxController {
  // Authentication model
  AuthModel authModel = AuthModel();

  // Login email controller
  TextEditingController userEmailController = TextEditingController();

  // Password controller
  TextEditingController passwordController = TextEditingController();

  // Variable to control password visibility
  RxBool passwordVisible = false.obs;

  // Variable that controls if the user will stay connected
  RxBool stayConnected = false.obs;

  // Function to clear the fields
  cleanFields() {
    userEmailController.clear();
    passwordController.clear();
    passwordVisible.value = false;
    stayConnected.value = false;
  }

  // Method to submit login credentials
  Future<void> submit() async {
    // Checks the state of the form key
    if (LoginFormKey.loginFormKey.currentState!.validate()) {
      // Creates an Auth instance with the provided data
      AuthModel authModel = AuthModel(
          userEmail: userEmailController.value.text,
          password: passwordController.value.text);

      // Submits the request
      await AuthService().requestToken(authModel: authModel);
    }
  }

  // Function to store data persistently (stay logged in)
  saveSecureData() async {
    if (stayConnected.value == true) {
      await LocalSecureData.saveData();

      await LocalSecureData.saveSecureData(
          'user_email', userEmailController.text);

      await LocalSecureData.saveSecureData('password', passwordController.text);
    } else {
      await LocalSecureData.deleteSecureData();
      await LocalSecureData.removeLogin();
    }
  }
}
