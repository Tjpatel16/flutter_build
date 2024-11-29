import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/window_service.dart';
import 'services/storage_service.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await WindowService.initializeWindow();
  await StorageService.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
