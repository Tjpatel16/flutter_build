import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flutter_info_state.dart';
import 'dart:io';

final flutterInfoProvider =
    AsyncNotifierProvider<FlutterInfoNotifier, FlutterInfoState>(
  () => FlutterInfoNotifier(),
);

class FlutterInfoNotifier extends AsyncNotifier<FlutterInfoState> {
  @override
  Future<FlutterInfoState> build() async {
    return _fetchVersions();
  }

  Future<FlutterInfoState> _fetchVersions() async {
    try {
      final flutterVersion = await _getFlutterVersion();
      final dartVersion = await _getDartVersion();
      return FlutterInfoState(
        flutterVersion: flutterVersion,
        dartVersion: dartVersion,
      );
    } catch (e) {
      throw Exception('Failed to fetch versions: $e');
    }
  }

  Future<String> _getFlutterVersion() async {
    try {
      final result = await Process.run('flutter', ['--version']);
      return result.stdout.toString().trim();
    } catch (e) {
      throw Exception('Flutter version not found: $e');
    }
  }

  Future<String> _getDartVersion() async {
    try {
      final result = await Process.run('dart', ['--version']);
      return result.stdout.toString().trim();
    } catch (e) {
      throw Exception('Dart version not found: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchVersions());
  }
}
