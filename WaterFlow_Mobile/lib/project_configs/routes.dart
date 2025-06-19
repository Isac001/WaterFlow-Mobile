import 'package:flutter/widgets.dart';
import 'package:waterflow_mobile/modules/home/screens/home_screen.dart';
import 'package:waterflow_mobile/modules/login/screens/login_screen.dart';
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

  };
}
