import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/project_configs/routes.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

// Main application widget that sets up the app's theme, routes, and localization
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Return a GetMaterialApp to enable GetX features
    return GetMaterialApp(
      title: 'WaterFlow Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeColor.globalTheme,
      initialRoute: Routes().initialRoute,
      routes: Routes().listRoutes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    );
  }
}
