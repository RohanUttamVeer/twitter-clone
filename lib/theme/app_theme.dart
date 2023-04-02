import 'package:flutter/material.dart';
import 'package:socially/theme/pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.darkPurpleColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.darkPurpleColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.deepPurpleAccentColor,
    ),
  );
}
