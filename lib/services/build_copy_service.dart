import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../riverpod/build/app_build_type.dart';
import '../riverpod/build/app_mode_type.dart';
import 'version_service.dart';

class BuildCopyService {
  static const String _baseOutputDir = 'FlutterBuild';

  /// Copies the built app to a versioned directory
  /// Format: FlutterBuild/{appName}/v{version}+{buildNumber}/{date}/{appName}_{releaseType}
  static Future<String> copyBuiltApp({
    required String sourceFilePath,
    required String appName,
    AppBuildType? buildType,
    AppModeType? modeType,
  }) async {
    try {
      // Normalize the source file path to handle spaces and special characters
      final normalizedSourcePath = path.normalize(sourceFilePath);
      
      if (!File(normalizedSourcePath).existsSync()) {
        throw Exception('Build output not found at: $normalizedSourcePath\nPlease ensure the build completed successfully.');
      }

      // Get app version info
      final versionInfo = await VersionService.getCurrentVersion();

      // Create version directory name
      final versionDir = versionInfo.toString();

      // Get current date
      final now = DateTime.now();
      final dateDir = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Create target filename
      String targetFileName = appName;
      if (buildType != null) {
        targetFileName += '_${buildType.name.toLowerCase()}';
      }
      if (modeType != null) {
        targetFileName += '_${modeType.name.toLowerCase()}';
      }

      // Add original file extension
      final fileExtension = path.extension(normalizedSourcePath);
      targetFileName += fileExtension;

      // Create full target directory path
      final homeDir = Platform.environment['HOME'] ?? '';
      final targetDir = path.normalize(path.join(homeDir, _baseOutputDir, appName, versionDir, dateDir));

      // Create target directory if it doesn't exist
      await Directory(targetDir).create(recursive: true);

      // Create full target file path
      var targetPath = path.join(targetDir, targetFileName);

      // If file exists, add number suffix
      var counter = 1;
      final baseName = path.basenameWithoutExtension(targetFileName);
      final extension = path.extension(targetFileName);
      
      while (await File(targetPath).exists()) {
        targetPath = path.join(targetDir, '${baseName}_$counter$extension');
        counter++;
      }

      // Copy the file
      await File(normalizedSourcePath).copy(targetPath);

      debugPrint('Successfully copied built app to: $targetPath');
      return targetPath;
    } catch (e) {
      debugPrint('Error copying built app: $e');
      rethrow;
    }
  }

  /// Gets the current build directory path
  static String getCurrentBuildDir() {
    final homeDir = Platform.environment['HOME'] ?? '';
    return path.join(homeDir, _baseOutputDir);
  }

  /// Opens the build directory in system file explorer
  static Future<void> openBuildDirectory() async {
    final buildDir = getCurrentBuildDir();
    try {
      if (Platform.isMacOS) {
        await Process.run('open', [buildDir]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [buildDir]);
      } else if (Platform.isWindows) {
        await Process.run('explorer', [buildDir]);
      }
    } catch (e) {
      debugPrint('Error opening build directory: $e');
      rethrow;
    }
  }
}
