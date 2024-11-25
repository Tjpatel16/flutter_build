import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

class WindowService {
  static Future<void> initializeWindow() async {
    try {
      if (!_isDesktopPlatform) return;

      await windowManager.ensureInitialized();

      const windowOptions = WindowOptions(
        size: Size(1280, 720),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        title: 'Flutter Build',
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });

      // Set minimum size to prevent window from becoming too small
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.setResizable(true);
      await windowManager.setHasShadow(true);
    } catch (e) {
      debugPrint('Error initializing window: $e');
      // Continue with default window settings
    }
  }

  static bool get _isDesktopPlatform =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
