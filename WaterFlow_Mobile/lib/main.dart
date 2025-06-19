import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:waterflow_mobile/controllers/general_controller.dart';
import 'package:waterflow_mobile/controllers/initializer_controllers.dart';
import 'package:waterflow_mobile/main_app.dart';

void main() async {

  // Ensure that widget binding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize GetX dependency injection
  Get.put(GeneralController());

  // Initialize controllers
  InitializerControllers();

  // Run the main application
  runApp(
    const SafeArea(child: MainApp(),
    )
  );
}
