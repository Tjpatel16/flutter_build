import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashProvider = StateNotifierProvider<SplashNotifier, bool>((ref) {
  return SplashNotifier();
});

class SplashNotifier extends StateNotifier<bool> {
  SplashNotifier() : super(true);

  Future<void> initSplash() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      state = false;
    } catch (e) {
      // Keep splash screen visible if there's an error
      state = true;
    }
  }
}
