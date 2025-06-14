import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/controllers/general_controller.dart';
import 'package:waterflow_mobile/controllers/initializer_controllers.dart';
import 'package:waterflow_mobile/modules/login/screens/login_screen.dart';

void main() async {

  // Initializing Flutter and the controllers
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(GeneralController());
  InitializerControllers();

  runApp(
    const GetMaterialApp(
      title: 'WaterFlow',
      debugShowCheckedModeBanner: false,

      // [TODO] Create the home screen and set it as the home
      home: LoginScreen(),
    ),
  );
}
