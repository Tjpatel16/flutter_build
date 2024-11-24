import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_build/screens/widgets/text_widget.dart';
import 'package:flutter_build/utils/field_constant.dart';

import '../../riverpod/splash/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ref.read(splashProvider.notifier).initSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2193b0),
              Color(0xFF6dd5ed),
            ],
          ),
        ),
        child: const Center(
          child: TextWidget(
            FieldConstant.appName,
            size: 32,
            color: Colors.white,
            weight: FontWeight.bold,
            isTitle: true,
          ),
        ),
      ),
    );
  }
}
