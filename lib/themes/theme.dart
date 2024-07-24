import 'package:flutter/material.dart';

ThemeData lightMode=ThemeData(
  brightness: Brightness.light,
  primaryTextTheme: TextTheme(
    headlineLarge: TextStyle(
        color: Colors.black),
    headlineMedium: TextStyle(
        color: Colors.grey.shade500),
    headlineSmall: TextStyle(color: Colors.grey.shade300)
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,
    primary: Colors.white,
    secondary: Colors.grey.shade100,
  ),

);

ThemeData darkMode=ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        primary: Colors.black,
        secondary: Colors.grey.shade900

    ),
  primaryTextTheme: TextTheme(
    headlineLarge: TextStyle(
        color: Colors.white),
    headlineMedium: TextStyle(
        color: Colors.grey.shade800),
      headlineSmall: TextStyle(color: Colors.grey.shade800)
  ),
);