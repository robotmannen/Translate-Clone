import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      inputDecorationTheme: const InputDecorationTheme(fillColor: Colors.white),
      scaffoldBackgroundColor: const Color(0xffededed),
      colorScheme: const ColorScheme.light(onPrimary: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
      inputDecorationTheme:
          const InputDecorationTheme(fillColor: Colors.white10),
      scaffoldBackgroundColor: Colors.white10,
      primaryColor: Colors.black12,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ));
}
