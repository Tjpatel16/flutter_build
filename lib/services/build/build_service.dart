import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/build_output.dart';
import '../../riverpod/home/home_provider.dart';
import '../../riverpod/build/build_output_provider.dart';
import 'steps/clean_step.dart';
import 'steps/dependencies_step.dart';
import 'steps/build_execution_step.dart';
import 'steps/version_update_step.dart';

class BuildService {
  final Ref ref;
  final void Function(String output, BuildOutputType type) addOutput;

  BuildService(this.ref, this.addOutput);

  void _updateLastCommandStatus(CommandStatus status) {
    final notifier = ref.read(buildOutputProvider.notifier);
    notifier.updateLastCommandStatus(status);
  }

  /*  Future<void> _copyBuildOutput({
    required String appName,
    required String version,
    required String buildNumber,
    required String sourcePath,
  }) async {
    try {
      final homeState = ref.read(homeProvider);

      if (!homeState.hasValue) {
        throw Exception('Home state not initialized');
      }

      final homeData = homeState.value!;
      final workingDir = homeData.selectedProjectPath!;

      const outputDirName = 'FlutterBuild';
      final projectRoot = Directory(workingDir).parent.path;
      final outputDir = Directory('$projectRoot/$outputDirName');

      // Create output directory if it doesn't exist
      if (!await outputDir.exists()) {
        await outputDir.create();
      }

      // Generate output filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFileName = '${appName}_${version}_${buildNumber}_$timestamp';

      // Source file paths based on platform
      final sourceFilePath = Platform.isMacOS
          ? '$sourcePath/Build/Products/Release-iphoneos/$appName.app'
          : '$sourcePath/app/outputs/flutter-apk/app-release.apk';

      final outputPath = Platform.isMacOS
          ? '${outputDir.path}/$outputFileName.app'
          : '${outputDir.path}/$outputFileName.apk';

      // Copy the build output
      if (await Directory(sourceFilePath).exists() ||
          await File(sourceFilePath).exists()) {
        await Process.run('cp', ['-R', sourceFilePath, outputPath]);
        addOutput(
          '📦 Build artifact copied to: $outputPath',
          BuildOutputType.success,
        );
      } else {
        throw Exception('Build output not found at: $sourceFilePath');
      }
    } catch (e) {
      addOutput(
        '❌ Failed to copy build output: $e',
        BuildOutputType.error,
      );
    }
  } */

  Future<void> startBuild() async {
    final homeState = ref.read(homeProvider);

    if (!homeState.hasValue) {
      throw Exception('Home state not initialized');
    }

    final homeData = homeState.value!;
    final workingDir = homeData.selectedProjectPath!;

    addOutput('=' * 50, BuildOutputType.info);
    addOutput('🚀 Starting build process...', BuildOutputType.info);
    addOutput('=' * 50, BuildOutputType.info);

    final steps = [
      VersionUpdateStep(ref),
      CleanStep(ref),
      DependenciesStep(ref),
      BuildExecutionStep(ref),
    ];

    try {
      for (final step in steps) {
        try {
          await step.execute(
            workingDir: workingDir,
            addOutput: addOutput,
          );
          _updateLastCommandStatus(CommandStatus.success);
        } catch (error) {
          _updateLastCommandStatus(CommandStatus.failed);
          rethrow;
        }
      }

      // Get app details from pubspec.yaml
      /* final pubspecFile = File('$workingDir/pubspec.yaml');
      final pubspecContent = await pubspecFile.readAsString();
      final pubspec = loadYaml(pubspecContent);

      final appName = pubspec['name'];
      final version = pubspec['version'].toString().split('+')[0];
      final buildNumber = pubspec['version'].toString().split('+')[1];

      // Start the build process
      final buildPath = Platform.isMacOS ? 'ios' : 'build';
      await _copyBuildOutput(
        appName: appName,
        version: version,
        buildNumber: buildNumber,
        sourcePath: '$workingDir/$buildPath',
      ); */

      await _printBuildSuccess();
    } catch (error) {
      await _printBuildFailure(error);
      rethrow;
    }
  }

  Future<void> _printBuildSuccess() async {
    addOutput('\n${'=' * 50}', BuildOutputType.success);
    addOutput(
      '✨ Build Process Completed Successfully!',
      BuildOutputType.success,
    );
    addOutput(
      '🕒 Finished at: ${DateTime.now().toString()}',
      BuildOutputType.info,
    );
    addOutput('${'=' * 50}\n', BuildOutputType.success);
  }

  Future<void> _printBuildFailure(Object error) async {
    addOutput('\n${'=' * 50}', BuildOutputType.error);
    addOutput(
      '❌ Build Process Failed!',
      BuildOutputType.error,
    );
    addOutput(
      'Error: $error',
      BuildOutputType.error,
    );
    addOutput(
      '⏱️ Failed at: ${DateTime.now().toString()}',
      BuildOutputType.error,
    );
    addOutput('${'=' * 50}\n', BuildOutputType.error);
  }
}
