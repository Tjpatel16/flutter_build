import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

final themeColorProvider = StateNotifierProvider<ThemeColorNotifier, Color>((ref) {
  return ThemeColorNotifier();
});

class ThemeColorNotifier extends StateNotifier<Color> {
  ThemeColorNotifier() : super(_loadThemeColor());

  static Color _loadThemeColor() {
    final savedColor = StorageService.settings.get('themeColor');
    if (savedColor == null) return Colors.blue;
    return Color(savedColor);
  }

  void setColor(Color color) {
    state = color;
    StorageService.settings.put('themeColor', color.value);
  }
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(_loadThemeMode());

  static ThemeMode _loadThemeMode() {
    final savedMode = StorageService.settings.get('themeMode', defaultValue: 'system');
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == savedMode,
      orElse: () => ThemeMode.system,
    );
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    StorageService.settings.put('themeMode', mode.name);
  }

  void toggleTheme() {
    final nextMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    setThemeMode(nextMode);
  }
}
