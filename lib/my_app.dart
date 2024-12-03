import 'package:flutter/material.dart';
import 'package:flutter_build/riverpod/splash/splash_provider.dart';
import 'package:flutter_build/screens/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_build/screens/pages/home_page.dart';
import 'package:toastification/toastification.dart';

import 'providers/theme_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Version check removed as it's handled by VersionInfo widget
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final themeColor = ref.watch(themeColorProvider);
    final isSplashPage = ref.watch(splashProvider);

    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Build',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: themeMode,
        home: isSplashPage ? const SplashPage() : const HomePage(),
      ),
    );
  }
}
