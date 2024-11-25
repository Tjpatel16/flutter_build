import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final themeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

final themeColorProvider = StateNotifierProvider<ThemeColorNotifier, Color>((ref) {
  return ThemeColorNotifier();
});

class ThemeColorNotifier extends StateNotifier<Color> {
  ThemeColorNotifier() : super(_loadSavedColor());

  static Color _loadSavedColor() {
    try {
      final savedColor = StorageService.settings?.get('themeColor');
      if (savedColor != null) {
        return Color(savedColor as int);
      }
    } catch (e) {
      debugPrint('Error loading theme color: $e');
    }
    return Colors.blue;
  }

  void changeColor(Color color) {
    try {
      StorageService.settings?.put('themeColor', color.value);
      state = color;
    } catch (e) {
      debugPrint('Error saving theme color: $e');
    }
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_loadSavedThemeMode());

  static ThemeMode _loadSavedThemeMode() {
    try {
      final savedMode = StorageService.settings?.get('themeMode', defaultValue: 'system') as String?;
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => ThemeMode.system,
      );
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      return ThemeMode.system;
    }
  }

  void changeTheme(ThemeMode mode) {
    try {
      StorageService.settings?.put('themeMode', mode.name);
      state = mode;
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }
}
