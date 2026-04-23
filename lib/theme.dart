import 'package:flutter/material.dart';

final ThemeData darkBlueTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white, // ✅ white background everywhere
  primaryColor: Color(0xFF1E3A8A), // dark// dark blue
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E3A8A), // dark
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF1E3A8A), // dark
    secondary: Color(0xFF1E3A8A), // dark
    surface: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1E3A8A), // dark
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF1E3A8A), // dark
    unselectedItemColor: Colors.grey,
  ),
);
