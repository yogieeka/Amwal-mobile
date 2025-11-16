import 'package:flutter/material.dart';

/// Islamic-inspired color palette for Material Design 3
class AppColors {
  AppColors._();

  // Primary Colors - Islamic Green
  static const Color primaryGreen = Color(0xFF00695C); // Teal 800
  static const Color primaryGreenLight = Color(0xFF4DB6AC); // Teal 300
  static const Color primaryGreenDark = Color(0xFF004D40); // Teal 900

  // Secondary Colors - Gold (representing wealth/amwal)
  static const Color secondaryGold = Color(0xFFFFB300); // Amber 600
  static const Color secondaryGoldLight = Color(0xFFFFD54F); // Amber 300
  static const Color secondaryGoldDark = Color(0xFFFF8F00); // Amber 800

  // Accent Colors
  static const Color accentBlue = Color(0xFF1976D2); // Blue 700
  static const Color accentPurple = Color(0xFF7B1FA2); // Purple 700

  // Status Colors
  static const Color success = Color(0xFF388E3C); // Green 700
  static const Color warning = Color(0xFFF57C00); // Orange 700
  static const Color error = Color(0xFFD32F2F); // Red 700
  static const Color info = Color(0xFF0288D1); // Light Blue 700

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Transaction Types
  static const Color income = Color(0xFF4CAF50); // Green
  static const Color expense = Color(0xFFE53935); // Red
  static const Color zakat = Color(0xFF00897B); // Teal
  static const Color sedekah = Color(0xFF8E24AA); // Purple
  static const Color investment = Color(0xFF1565C0); // Blue

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Gradient Colors
  static const LinearGradient islamicGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [secondaryGold, secondaryGoldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient zakatGradient = LinearGradient(
    colors: [Color(0xFF00695C), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
