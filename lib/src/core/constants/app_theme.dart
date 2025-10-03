import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: Colors.white,
    background: AppColors.backgroundColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    onBackground: Colors.black87,
  ),
  scaffoldBackgroundColor: AppColors.backgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
  ),
  cardColor: Colors.white,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: Colors.black54,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8BC34A),
    secondary: Color(0xFF90CAF9),
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white70,
    onBackground: Colors.white70,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
  ),
  cardColor: const Color(0xFF1E1E1E),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Color(0xFF8BC34A),
    unselectedItemColor: Colors.white70,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF8BC34A),
      foregroundColor: Colors.black,
    ),
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
);
