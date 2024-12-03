import 'dart:io';
import 'package:path/path.dart' as path;

import '../../../models/build_output.dart';
import '../../../riverpod/build/app_build_provider.dart';
import '../../../riverpod/build/app_build_type.dart';
import '../../../riverpod/build/app_mode_provider.dart';
import '../../build_copy_service.dart';
import '../../pubspec_service.dart';
import '../build_step.dart';

class BuildCopyStep extends BuildStep {
  BuildCopyStep(super.ref);

  String _getBuildOutputPath(String workingDir, AppBuildType buildType) {
    // Normalize the path to handle spaces and special characters
    final normalizedWorkingDir = path.normalize(workingDir);
    
    switch (buildType) {
      case AppBuildType.androidApk:
        return path.join(normalizedWorkingDir, 'build', 'app', 'outputs', 'flutter-apk',
            'app-release.apk');
      case AppBuildType.androidBundle:
        return path.join(normalizedWorkingDir, 'build', 'app', 'outputs', 'bundle',
            'release', 'app-release.aab');
      case AppBuildType.iosIpa:
        return path.join(normalizedWorkingDir, 'build', 'ios', 'ipa', 'app.ipa');
      case AppBuildType.webApp:
        return path.join(normalizedWorkingDir, 'build', 'web');
    }
  }

  Future<String> _getAppName(String workingDir) {
    final pubspecService = PubspecService();
    pubspecService.initialize(workingDir);
    
    try {
      return pubspecService.getInfo().then((info) => info.name);
    } catch (e) {
      throw Exception('Failed to get project name: $e');
    }
  }

  @override
  Future<void> execute({
    required String workingDir,
    required void Function(String output, BuildOutputType type) addOutput,
  }) async {
    final buildType = ref.read(appBuildTypeProvider);
    if (buildType == null) {
      throw Exception('Build type not selected');
    }

    final appMode = ref.read(appModeTypeProvider);
    addOutput('\n${'>' * 50}\n', BuildOutputType.info);
    addOutput('📦 Step 4/4: Copying build artifacts...', BuildOutputType.info);

    final outputPath = _getBuildOutputPath(workingDir, buildType);
    if (!File(outputPath).existsSync() && !Directory(outputPath).existsSync()) {
      addOutput(
          '⚠️ Build output not found at: $outputPath', BuildOutputType.warning);
      return;
    }

    try {
      final appName = await _getAppName(workingDir);
      final targetPath = await BuildCopyService.copyBuiltApp(
        sourceFilePath: outputPath,
        appName: appName,
        buildType: buildType,
        modeType: appMode,
      );

      addOutput(
          '✅ Build artifact copied to: $targetPath', BuildOutputType.success);
    } catch (e) {
      addOutput(
          '⚠️ Failed to copy build artifact: $e', BuildOutputType.warning);
    }
  }
}
