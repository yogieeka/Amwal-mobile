import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Provider for managing theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Notifier for theme mode state
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  /// Load theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(AppConstants.keyThemeMode);

      if (themeModeString != null) {
        switch (themeModeString) {
          case 'light':
            state = ThemeMode.light;
            break;
          case 'dark':
            state = ThemeMode.dark;
            break;
          case 'system':
            state = ThemeMode.system;
            break;
        }
      }
    } catch (e) {
      // If error, use default light mode
      state = ThemeMode.light;
    }
  }

  /// Set theme mode to light
  Future<void> setLightMode() async {
    state = ThemeMode.light;
    await _saveThemeMode('light');
  }

  /// Set theme mode to dark
  Future<void> setDarkMode() async {
    state = ThemeMode.dark;
    await _saveThemeMode('dark');
  }

  /// Set theme mode to system
  Future<void> setSystemMode() async {
    state = ThemeMode.system;
    await _saveThemeMode('system');
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      await setDarkMode();
    } else {
      await setLightMode();
    }
  }

  /// Save theme mode to shared preferences
  Future<void> _saveThemeMode(String mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyThemeMode, mode);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => state == ThemeMode.light;

  /// Check if current theme follows system
  bool get isSystemMode => state == ThemeMode.system;
}
