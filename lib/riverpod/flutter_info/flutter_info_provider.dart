import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flutter_info_state.dart';
import 'dart:async';
import 'package:flutter_build/services/flutter_path_service.dart';

final flutterInfoProvider =
    AsyncNotifierProvider<FlutterInfoNotifier, FlutterInfoState>(
  () => FlutterInfoNotifier(),
);

class FlutterInfoNotifier extends AsyncNotifier<FlutterInfoState> {
  final _flutterService = FlutterPathService();

  @override
  Future<FlutterInfoState> build() async {
    return _fetchVersions();
  }

  Future<FlutterInfoState> _fetchVersions() async {
    try {
      final info = await _flutterService.getFlutterInfo();

      if (info.containsKey('error')) {
        return const FlutterInfoState(
          flutterVersion: 'Not found',
          dartVersion: 'Not found',
          isFlutterAvailable: false,
        );
      }

      // Parse version string to extract Flutter and Dart versions
      final versionString = info['version'] ?? '';
      final flutterVersion = RegExp(r'Flutter (\d+\.\d+\.\d+)')
              .firstMatch(versionString)
              ?.group(1) ??
          'Unknown';
      final dartVersion =
          RegExp(r'Dart (\d+\.\d+\.\d+)').firstMatch(versionString)?.group(1) ??
              'Unknown';

      return FlutterInfoState(
        flutterVersion: flutterVersion,
        dartVersion: dartVersion,
        isFlutterAvailable: true,
      );
    } catch (e) {
      return FlutterInfoState(
        flutterVersion: "Not found",
        dartVersion: "Not found",
        isFlutterAvailable: false,
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchVersions());
  }
}
