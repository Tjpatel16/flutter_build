import '../../../riverpod/version/version_provider.dart';
import '../../../models/build_output.dart';
import '../build_step.dart';
import 'dart:io';

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
    final pubspecFile = File('$workingDir/pubspec.yaml');
    final content = await pubspecFile.readAsString();

    // Update version in pubspec.yaml
    final lines = content.split('\n');
    bool versionUpdated = false;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith('version:')) {
        lines[i] = 'version: ${versionInfo.fullVersion}';
        versionUpdated = true;
        break;
      }
    }

    if (!versionUpdated) {
      throw Exception('Version line not found in pubspec.yaml');
    }

    await pubspecFile.writeAsString(lines.join('\n'));
    addOutput('✅ Version updated to ${versionInfo.fullVersion}\n',
        BuildOutputType.success);
  }
}
