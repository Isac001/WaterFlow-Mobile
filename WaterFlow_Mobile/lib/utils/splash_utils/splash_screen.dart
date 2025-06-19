import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.whiteColor,
      body: Center(
        child: Image.asset(
          "assets/app_images/Logo_With_Name.png",
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ),
    );
  }
}