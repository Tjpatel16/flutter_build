import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/pubspec_service.dart';

class VersionInfo {
  final String version;
  final String buildNumber;

  VersionInfo({
    required this.version,
    required this.buildNumber,
  });

  String get fullVersion => '$version+$buildNumber';

  factory VersionInfo.fromPubspecInfo(PubspecInfo info) {
    return VersionInfo(
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }
}

final versionInfoProvider = StateNotifierProvider<VersionInfoNotifier, AsyncValue<VersionInfo>>((ref) {
  return VersionInfoNotifier();
});

class VersionInfoNotifier extends StateNotifier<AsyncValue<VersionInfo>> {
  VersionInfoNotifier() : super(const AsyncValue.loading());

  Future<void> loadVersion(String projectPath) async {
    try {
      state = const AsyncValue.loading();
      final pubspecService = PubspecService();
      pubspecService.initialize(projectPath);
      final info = await pubspecService.getInfo();
      state = AsyncValue.data(VersionInfo.fromPubspecInfo(info));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateVersion({String? version, String? buildNumber}) async {
    if (!state.hasValue) return;

    try {
      final pubspecService = PubspecService();
      await pubspecService.updateVersion(
        version: version,
        buildNumber: buildNumber,
      );
      
      final info = await pubspecService.getInfo();
      state = AsyncValue.data(VersionInfo.fromPubspecInfo(info));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
