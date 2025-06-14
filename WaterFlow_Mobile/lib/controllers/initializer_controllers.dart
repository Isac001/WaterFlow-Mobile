import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/modules/login/controllers/login_screen_controller.dart';

// Class to initialize all controllers in the app
class InitializerControllers {
  
  InitializerControllers() {

    // Initializes the authentication controller
    Get.lazyPut(() => AuthController());

    // Initializes the login controller
    Get.lazyPut(() => LoginScreenController());
  }
}
