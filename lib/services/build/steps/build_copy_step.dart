import 'dart:io';

import 'package:flutter_build/riverpod/build/app_mode_type.dart';
import 'package:path/path.dart' as path;

import '../../../models/build_output.dart';
import '../../../riverpod/build/app_build_provider.dart';
import '../../../riverpod/build/app_build_type.dart';
import '../../../riverpod/build/app_mode_provider.dart';
import '../../../riverpod/version/version_provider.dart';
import '../../build_copy_service.dart';
import '../../pubspec_service.dart';
import '../build_step.dart';

class BuildCopyStep extends BuildStep {
  BuildCopyStep(super.ref);

  String _getBuildOutputPath(
      String workingDir, AppBuildType buildType, AppModeType appMode) {
    // Normalize the path to handle spaces and special characters
    final normalizedWorkingDir = path.normalize(workingDir);

    final appModeName = appMode.copyName;

    switch (buildType) {
      case AppBuildType.androidApk:
        return path.join(normalizedWorkingDir, 'build', 'app', 'outputs',
            'flutter-apk', 'app-$appModeName.apk');
      case AppBuildType.androidBundle:
        return path.join(normalizedWorkingDir, 'build', 'app', 'outputs',
            'bundle', appModeName, 'app-$appModeName.aab');
      case AppBuildType.iosIpa:
        return path.join(
            normalizedWorkingDir, 'build', 'ios', 'ipa', 'app.ipa');
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

    final outputPath = _getBuildOutputPath(workingDir, buildType, appMode!);
    if (!File(outputPath).existsSync() && !Directory(outputPath).existsSync()) {
      addOutput(
          '⚠️ Build output not found at: $outputPath', BuildOutputType.warning);
      return;
    }

    final version = ref.read(versionInfoProvider);
    String versionString = "${version.value!.version}+${version.value!.buildNumber}";
    try {
      final appName = await _getAppName(workingDir);
      final targetPath = await BuildCopyService.copyBuiltApp(
        sourceFilePath: outputPath,
        appName: appName,
        buildType: buildType,
        modeType: appMode,
        version: versionString,
      );

      addOutput(
          '✅ Build artifact copied to: $targetPath', BuildOutputType.success);
      addOutput(
          '✅ Your app is now saved in a safe place - no need to worry about losing it!',
          BuildOutputType.success);
      addOutput('✅ You can now proceed with building another app.',
          BuildOutputType.success);
    } catch (e) {
      addOutput(
          '⚠️ Failed to copy build artifact: $e', BuildOutputType.warning);
    }
  }
}
