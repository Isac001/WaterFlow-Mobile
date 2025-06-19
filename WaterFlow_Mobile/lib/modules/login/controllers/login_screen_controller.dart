// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:waterflow_mobile/auth/models/auth_model.dart';
// import 'package:waterflow_mobile/auth/services/auth_service.dart';
// import 'package:waterflow_mobile/modules/login/keys/login_form_key.dart';
// import 'package:waterflow_mobile/project_configs/local_secure_data_config.dart';

// // Main Class
// class LoginScreenController extends GetxController {
//   // Authentication model
//   AuthModel authModel = AuthModel();

//   // Login email controller
//   TextEditingController userEmailController = TextEditingController();

//   // Password controller
//   TextEditingController passwordController = TextEditingController();

//   // Variable to control password visibility
//   RxBool passwordVisible = false.obs;

//   // Variable that controls if the user will stay connected
//   RxBool stayConnected = false.obs;

//   // Function to clear the fields
//   cleanFields() {
//     userEmailController.clear();
//     passwordController.clear();
//     passwordVisible.value = false;
//     stayConnected.value = false;
//   }

//   // Method to submit login credentials
//   Future<void> submit() async {
//     // Checks the state of the form key
//     if (LoginFormKey.loginFormKey.currentState!.validate()) {
//       // Creates an Auth instance with the provided data
//       AuthModel authModel = AuthModel(
//           userEmail: userEmailController.value.text,
//           password: passwordController.value.text);

//       // Submits the request
//       await AuthService().requestToken(authModel: authModel);
//     }
//   }



//   // Function to store data persistently (stay logged in)
//   saveSecureData() async {
//     if (stayConnected.value == true) {
//       await LocalSecureData.saveData();

//       await LocalSecureData.saveSecureData(
//           'user_email', userEmailController.text);

//       await LocalSecureData.saveSecureData('password', passwordController.text);
//     } else {
//       await LocalSecureData.deleteSecureData();
//       await LocalSecureData.removeLogin();
//     }
//   }
// }

///[TODO] Remove this comment when the code is complete.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/models/auth_model.dart';
import 'package:waterflow_mobile/auth/services/auth_service.dart';
import 'package:waterflow_mobile/modules/login/keys/login_form_key.dart';
import 'package:waterflow_mobile/project_configs/local_secure_data_config.dart';

/// Manages the state and logic for the Login screen.
class LoginScreenController extends GetxController {
  AuthModel authModel = AuthModel();

  // Form fields controllers and state.
  TextEditingController userEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool passwordVisible = false.obs;
  RxBool stayConnected = false.obs;

  /// Initializes the form. If 'stay connected' was previously checked,
  /// it loads the saved credentials.
  Future<void> prepareForm() async {
    // Read the user's preference to stay connected.
    stayConnected.value = await LocalSecureData.getStayConnected();

    if (stayConnected.value == true) {
      // If enabled, fetch saved credentials.
      userEmailController.text = await LocalSecureData.readSecuredata('user_email') ?? '';
      passwordController.text = await LocalSecureData.readSecuredata('password') ?? '';
    } else {
      // Otherwise, ensure fields are empty.
      cleanFields();
    }
  }

  /// Validates, manages credentials, and submits the login form.
  Future<void> submit() async {
    // First, validate the form inputs.
    if (!LoginFormKey.loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      // Save or delete credentials based on the 'stayConnected' checkbox state.
      await _manageCredentials();

      // Create the auth model with the form data.
      AuthModel authModel = AuthModel(
          userEmail: userEmailController.text,
          password: passwordController.text);

      // Send the login request to the backend.
      await AuthService().requestToken(authModel: authModel);

    } catch (e) {
      // Handle login errors.
      Get.snackbar(
        'Login Error',
        'Invalid user or password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  /// Saves or deletes credentials based on the 'stayConnected' checkbox.
  Future<void> _manageCredentials() async {
    // Save the current preference for the checkbox.
    await LocalSecureData.setStayConnected(stayConnected.value);

    if (stayConnected.value) {
      // If the box is checked, save the email and password.
      await LocalSecureData.saveSecureData('user_email', userEmailController.text);
      await LocalSecureData.saveSecureData('password', passwordController.text);
    } else {
      // If the box is not checked, delete any previously saved credentials.
      await LocalSecureData.deleteSavedCredentials();
    }
  }

  /// Clears the email and password text fields.
  void cleanFields() {
    userEmailController.clear();
    passwordController.clear();
  }
}