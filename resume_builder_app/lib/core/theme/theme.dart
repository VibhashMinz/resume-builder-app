import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryLight = Color(0xFF2196F3);
  static const Color _primaryDark = Color(0xFF1976D2);
  static const Color _accentLight = Color(0xFF03A9F4);
  static const Color _accentDark = Color(0xFF0288D1);
  static const Color _backgroundLight = Color(0xFFFFFFFF);
  static const Color _backgroundDark = Color(0xFF121212);
  static const Color _surfaceLight = Color(0xFFF5F5F5);
  static const Color _surfaceDark = Color(0xFF1E1E1E);
  static const Color _textLight = Color(0xFF212121);
  static const Color _textDark = Color(0xFFE0E0E0);
  static const Color _errorColor = Color(0xFFD32F2F);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryLight,
      secondary: _accentLight,
      surface: _surfaceLight,
      // background: _backgroundLight,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryLight,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _backgroundLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: _backgroundLight),
    ),
    cardTheme: CardTheme(
      color: _backgroundLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryLight,
        foregroundColor: _backgroundLight,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: _textLight, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: _textLight, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: _textLight, fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: _textLight, fontSize: 18),
      bodyMedium: TextStyle(color: _textLight, fontSize: 16),
      bodySmall: TextStyle(color: _textLight, fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _textLight.withAlpha(1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryLight, width: 2),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryDark,
      secondary: _accentDark,
      surface: _surfaceDark,
      //   background: _backgroundDark,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceDark,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _textDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: _textDark),
    ),
    cardTheme: CardTheme(
      color: _surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryDark,
        foregroundColor: _textDark,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: _textDark, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: _textDark, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: _textDark, fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: _textDark, fontSize: 18),
      bodyMedium: TextStyle(color: _textDark, fontSize: 16),
      bodySmall: TextStyle(color: _textDark, fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _backgroundDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _textDark.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryDark, width: 2),
      ),
    ),
  );
}
