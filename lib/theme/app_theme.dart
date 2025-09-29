import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF00796B),
    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF00796B),
      secondary: Colors.orangeAccent,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.orangeAccent),
      bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.teal.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
      ),
    ),
  );

  // ignore: non_constant_identifier_names
  static ThemeData DarkTheme = ThemeData(primaryColor: const Color(0xFF00796B), // Same primary color
    scaffoldBackgroundColor: const Color(0xFF121212), // Very dark background (Standard for Material Dark)

    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.teal,
      brightness: Brightness.dark, // Crucial for dark mode
    ).copyWith(
      primary: const Color(0xFF00796B),
      secondary: Colors.orangeAccent,
      surface: const Color(0xFF1E1E1E), // Darker surface for Cards/Dialogs
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white, // White headlines on dark background
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70), // Light text on dark background
      bodySmall: TextStyle(fontSize: 14, color: Colors.white54),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00796B), // Teal background
        foregroundColor: Colors.white, // White text
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C), // Darker fill color for input fields
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // Using the accent color for focus indicator
        borderSide: BorderSide(color: Colors.orangeAccent, width: 2), 
      ),
      // Set label/hint text color for dark theme
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
    ),
    );
}
