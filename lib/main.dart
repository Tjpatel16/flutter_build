import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/window_service.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowService.initializeWindow();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
