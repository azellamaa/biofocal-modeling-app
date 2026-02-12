import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Pink Theme
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFF48FB1);
  static const Color darkPink = Color(0xFFC2185B);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF616161);

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPink,
        foregroundColor: white,
      ),
    );
  }
}
