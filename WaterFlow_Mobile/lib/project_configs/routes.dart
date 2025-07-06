import 'package:flutter/widgets.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/screens/daily_water_consumption_screen.dart';
import 'package:waterflow_mobile/modules/home/screens/home_screen.dart';
import 'package:waterflow_mobile/modules/login/screens/login_screen.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/screens/monthly_detail_graph_screen.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/screens/monthly_water_consumption_screen.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/screens/weekly_detail_screen.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/screens/weekly_water_consumption_screen.dart';
import 'package:waterflow_mobile/utils/splash_utils/splash_screen.dart';

class Routes {
  // Variavel estatica para armazenar a rota incial
  String initialRoute = '/';

  // Map para relacionar as chaves (Rotas) aos WidgetBuilders (Telas)
  Map<String, Widget Function(BuildContext)> listRoutes =
      <String, WidgetBuilder>{

    // [SPLASH ROUTES]
    '/': (context) => const SplashScreen(),

    // [HOME ROUTES]
    '/home': (context) => const HomeScreen(),

    // [LOGIN ROUTES]
    '/login': (context) => const LoginScreen(),

    // [DAILY WATER CONSUMPTION ROUTES]
    '/dailyWaterConsumption': (context) => const DailyWaterConsumptionScreen(),

    // [WEAKLY WATER CONSUMPTION ROUTES]
    '/weeklyWaterConsumption': (context) => const WeeklyWaterConsumptionScreen(),

    // [WEAKLY WATER CONSUMPTION ROUTES]
    '/weeklyDetail': (context) => const WeeklyDetailScreen(),

    // [MONTHLY WATER CONSUMPTION ROUTES]
    '/monthlyWaterConsumption': (context) => const MonthlyWaterConsumptionScreen(),

    // [MONTHLY WATER CONSUMPTION ROUTES]
    '/monthlyDetail': (context) => const MonthlyDetailGraphScreen()

  };
}
