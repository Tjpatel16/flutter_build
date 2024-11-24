import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashProvider = StateNotifierProvider<SplashNotifier, bool>((ref) {
  return SplashNotifier();
});

class SplashNotifier extends StateNotifier<bool> {
  SplashNotifier() : super(true);

  Future<void> initSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    state = false;
  }
}
