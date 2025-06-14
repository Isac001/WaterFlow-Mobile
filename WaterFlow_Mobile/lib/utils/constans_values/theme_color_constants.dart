import 'package:flutter/material.dart';

class ThemeColor {
  // Create an instance of the ThemeColor class
  ThemeColor._();

  static const primaryColor = Color(0xFF133a63);
  static const secondaryColor = Color(0xFF009C34);
  static const blackColor = Color(0xFF000000);
  static const whiteColor = Color(0xFFFFFFFF);
  static const redAccent = Color(0xFFCC2000);
  static const redColor = Color(0xFFF44336);
  static const greyColor = Color(0xFF9E9E9E);
  static const yellowColor = Color(0xFFE5D900);
  static const orangeColor = Color(0xFFE5A900);
  static const colorSuccess = Color(0xFF009C34);
  static const goldColor = Color(0xFFFFD700);

  static const colorReadOnly = Color(0xFFCAC8C8);
  static const transparentColor = Colors.transparent;

  // Define a static variable to set the global visual theme configuration for a MaterialApp
  static final ThemeData globalTheme = ThemeData(
    // Setting primaryColor
    primaryColor: primaryColor,

    // Setting visual density to get the value from the native OS
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Setting color schemes
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
  );
}