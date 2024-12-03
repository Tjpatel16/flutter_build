import '../../../riverpod/version/version_provider.dart';
import '../../../models/build_output.dart';
import '../build_step.dart';
import '../../pubspec_service.dart';

class VersionUpdateStep extends BuildStep {
  VersionUpdateStep(super.ref);

  @override
  Future<void> execute({
    required String workingDir,
    required void Function(String output, BuildOutputType type) addOutput,
  }) async {
    addOutput('📝 Updating version information...', BuildOutputType.info);

    final versionState = ref.read(versionInfoProvider);
    if (!versionState.hasValue) {
      throw Exception('Version information not loaded');
    }

    final versionInfo = versionState.value!;
    final pubspecService = PubspecService();
    pubspecService.initialize(workingDir);

    try {
      await pubspecService.updateVersion(
        version: versionInfo.version,
        buildNumber: versionInfo.buildNumber,
      );
      addOutput('✅ Version updated to ${versionInfo.fullVersion}\n',
          BuildOutputType.success);
    } catch (e) {
      throw Exception('Failed to update version: $e');
    }
  }
}
