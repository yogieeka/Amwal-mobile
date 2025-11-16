import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Material Design 3 theme configuration for the app
class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryGreenLight,
      onPrimaryContainer: AppColors.primaryGreenDark,

      secondary: AppColors.secondaryGold,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryGoldLight,
      onSecondaryContainer: AppColors.secondaryGoldDark,

      tertiary: AppColors.accentBlue,
      onTertiary: AppColors.white,

      error: AppColors.error,
      onError: AppColors.white,

      background: AppColors.backgroundLight,
      onBackground: AppColors.textPrimaryLight,

      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,

      surfaceVariant: AppColors.grey100,
      onSurfaceVariant: AppColors.textSecondaryLight,

      outline: AppColors.grey300,
      outlineVariant: AppColors.grey200,

      shadow: AppColors.black.withOpacity(0.1),
      scrim: AppColors.black.withOpacity(0.5),
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.white,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(
          color: AppColors.primaryGreen,
          width: 1.5,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondaryLight,
        fontSize: 16,
      ),
      hintStyle: const TextStyle(
        color: AppColors.grey400,
        fontSize: 16,
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryGold,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: AppColors.white,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey100,
      deleteIconColor: AppColors.grey600,
      labelStyle: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.grey700,
      size: 24,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: AppColors.textPrimaryLight,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryLight,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryLight,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.textPrimaryLight,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textPrimaryLight,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textSecondaryLight,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimaryLight,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textSecondaryLight,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondaryLight,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryGreenLight,
      onPrimary: AppColors.black,
      primaryContainer: AppColors.primaryGreenDark,
      onPrimaryContainer: AppColors.primaryGreenLight,

      secondary: AppColors.secondaryGoldLight,
      onSecondary: AppColors.black,
      secondaryContainer: AppColors.secondaryGoldDark,
      onSecondaryContainer: AppColors.secondaryGoldLight,

      tertiary: AppColors.accentBlue,
      onTertiary: AppColors.white,

      error: AppColors.error,
      onError: AppColors.white,

      background: AppColors.backgroundDark,
      onBackground: AppColors.textPrimaryDark,

      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,

      surfaceVariant: AppColors.grey800,
      onSurfaceVariant: AppColors.textSecondaryDark,

      outline: AppColors.grey700,
      outlineVariant: AppColors.grey800,

      shadow: AppColors.black.withOpacity(0.3),
      scrim: AppColors.black.withOpacity(0.7),
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surfaceDark,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryGreenLight,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryGoldLight,
      foregroundColor: AppColors.black,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Text Theme for Dark Mode
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textPrimaryDark,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
      ),
    ),
  );
}
