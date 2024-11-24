import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

class WindowService {
  static const String appName = 'Flutter Build';

  static Future<void> initializeWindow() async {
    if (!_isDesktopPlatform) return;

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: appName,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    final screenBounds = await windowManager.getBounds();
    final screenSize = screenBounds.size;

    // Define a maximum size (e.g., 1920x1080 for Full HD)
    const maxWidth = 1920.0;
    const maxHeight = 1080.0;

    // Calculate the desired size
    final newWidth = screenSize.width > maxWidth ? maxWidth : screenSize.width;
    final newHeight =
        screenSize.height > maxHeight ? maxHeight : screenSize.height;

    await windowManager.setSize(Size(newWidth, newHeight));
    await windowManager.setMaximumSize(const Size(maxWidth, maxHeight));
    await windowManager.setResizable(true);
    await windowManager.setHasShadow(true);
  }

  static bool get _isDesktopPlatform =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;




}
