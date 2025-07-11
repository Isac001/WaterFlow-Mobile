import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/controllers/flow_reading_controller.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/controllers/bimonthly_water_consumption_controller.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/controllers/daily_water_consumption_controller.dart';
// import 'package:waterflow_mobile/modules/home/controllers/home_screen_controller.dart';
import 'package:waterflow_mobile/modules/login/controllers/login_screen_controller.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/controllers/monthly_water_consumption_controller.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/controllers/weekly_water_consumption_controller.dart';

// Class to initialize all controllers in the app
class InitializerControllers {
  InitializerControllers() {

    // Initializes the authentication controller
    Get.lazyPut(() => AuthController());

    // Initializes the login controller
    Get.lazyPut(() => LoginScreenController());

    //[TODO] Remove the home controller if necessary
    // Initializes the home controller
    // Get.lazyPut(() => HomeScreenController());

    // Initializes the flow reading controller
    Get.lazyPut(() => FlowReadingController());

    // Initializes the daily water consumption controller
    Get.lazyPut(() => DailyWaterConsumptionController());

    // Initializes the weekly water consumption controller
    Get.lazyPut(() => WeeklyWaterConsumptionController());

    // Initializes the monthly water consumption controller
    Get.lazyPut(() => MonthlyWaterConsumptionController());

    // Initializes the bimonthly water consumption controller
    Get.lazyPut(() => BimonthlyWaterConsumptionController());
  }
}
