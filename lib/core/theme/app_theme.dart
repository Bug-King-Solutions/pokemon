import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Logo Colors
  static const Color primaryRed = Color(0xFFE44326);
  static const Color limeGreen = Color(0xFFC2D536);
  static const Color goldenOrange = Color(0xFFF0AF1D);
  static const Color deepBurgundy = Color(0xFF90193D);
  static const Color creamWhite = Color(0xFFFFF8F0);

  // Type Colors
  static const Map<String, Color> typeColors = {
    'grass': Color(0xFFA8E6CF),
    'fire': Color(0xFFFFB6B9),
    'water': Color(0xFFB4D9F5),
    'electric': Color(0xFFFFF4A3),
    'fairy': Color(0xFFF6C1CC),
    'mystic': Color(0xFFC7B9FF),
    'air': Color(0xFFE0E7FF),
    'shadow': Color(0xFFB8A9C9),
  };

  // Rarity Colors
  static const Map<String, Color> rarityColors = {
    'common': Color(0xFF9E9E9E),
    'rare': Color(0xFF4FC3F7),
    'epic': Color(0xFFBA68C8),
    'legendary': Color(0xFFFFD700),
  };

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryRed,
        secondary: limeGreen,
        tertiary: goldenOrange,
        surface: creamWhite,
        background: creamWhite,
        error: primaryRed,
      ),
      scaffoldBackgroundColor: creamWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: deepBurgundy),
        titleTextStyle: TextStyle(
          color: deepBurgundy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: deepBurgundy,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: deepBurgundy,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: deepBurgundy,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: deepBurgundy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: deepBurgundy,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: deepBurgundy,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}
