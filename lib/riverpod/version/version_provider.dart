import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaml/yaml.dart';

class VersionInfo {
  final String version;
  final String buildNumber;

  VersionInfo({
    required this.version,
    required this.buildNumber,
  });

  factory VersionInfo.fromYaml(String yamlContent) {
    final yaml = loadYaml(yamlContent) as Map;
    return VersionInfo(
      version: yaml['version']?.toString().split('+')[0] ?? '1.0.0',
      buildNumber: yaml['version']?.toString().split('+')[1] ?? '1',
    );
  }

  String get fullVersion => '$version+$buildNumber';
}

final versionInfoProvider = StateNotifierProvider<VersionInfoNotifier, AsyncValue<VersionInfo>>((ref) {
  return VersionInfoNotifier();
});

class VersionInfoNotifier extends StateNotifier<AsyncValue<VersionInfo>> {
  VersionInfoNotifier() : super(const AsyncValue.loading());

  Future<void> loadVersion(String projectPath) async {
    try {
      state = const AsyncValue.loading();
      final pubspecFile = File('$projectPath/pubspec.yaml');
      final yamlContent = await pubspecFile.readAsString();
      state = AsyncValue.data(VersionInfo.fromYaml(yamlContent));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateVersion({String? version, String? buildNumber}) async {
    if (!state.hasValue) return;

    final currentVersion = state.value!;
    final newVersion = VersionInfo(
      version: version ?? currentVersion.version,
      buildNumber: buildNumber ?? currentVersion.buildNumber,
    );

    state = AsyncValue.data(newVersion);
  }
}
