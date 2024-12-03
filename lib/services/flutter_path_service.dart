import 'dart:io';
import 'package:path/path.dart' as path;

class FlutterPathService {
  static final FlutterPathService _instance = FlutterPathService._internal();
  factory FlutterPathService() => _instance;
  FlutterPathService._internal();

  Map<String, String>? _cachedFlutterInfo;

  static bool get isWindows => Platform.isWindows;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isLinux => Platform.isLinux;

  Future<Map<String, String>> getFlutterInfo() async {
    if (_cachedFlutterInfo != null) {
      return _cachedFlutterInfo!;
    }

    final envFiles = _getEnvFilePaths();

    for (final envFile in envFiles) {
      if (await File(envFile).exists()) {
        try {
          final content = await File(envFile).readAsString();

          // Extract all potential paths from environment file
          final pathMatches = RegExp(
            r'(?:^|export\s+|setx\s+)?(?:PATH|FLUTTER_ROOT|FLUTTER_HOME)=([^;\n\r]+)',
            multiLine: true,
          ).allMatches(content);

          for (final match in pathMatches) {
            final pathValue = match.group(1)?.trim();
            if (pathValue != null) {
              // Handle both single path and PATH-style multiple paths
              final paths = pathValue.contains(isWindows ? ';' : ':')
                  ? pathValue.split(isWindows ? ';' : ':')
                  : [pathValue];

              for (final p in paths) {
                final normalizedPath =
                    p.replaceAll('"', '').replaceAll("'", '').trim();

                // If path contains flutter/bin, get the parent directory
                if (normalizedPath
                    .contains('flutter${Platform.pathSeparator}bin')) {
                  final parts =
                      normalizedPath.split('${Platform.pathSeparator}bin');
                  final flutterRoot = parts[0];
                  final result =
                      await _validateFlutterPath(flutterRoot, envFile);
                  if (result != null) {
                    _cachedFlutterInfo = result;
                    return result;
                  }
                }
                // If path points directly to flutter directory
                else if (normalizedPath.endsWith('flutter')) {
                  final result =
                      await _validateFlutterPath(normalizedPath, envFile);
                  if (result != null) {
                    _cachedFlutterInfo = result;
                    return result;
                  }
                }
              }
            }
          }
        } catch (e) {
          continue;
        }
      }
    }

    _cachedFlutterInfo = {'error': 'Flutter SDK not found'};
    return _cachedFlutterInfo!;
  }

  static List<String> _getEnvFilePaths() {
    final paths = <String>{}; // Using Set to avoid duplicates
    final home = Platform.environment['HOME'];
    final userProfile = Platform.environment['USERPROFILE'];

    if (isMacOS) {
      if (home != null) {
        paths.addAll([
          '$home/.zshrc',
          '$home/.bashrc',
          '$home/.bash_profile',
          '$home/.profile',
          '$home/Library/Application Support/flutter/settings',
          '$home/.flutter',
        ]);
      }
    } else if (isLinux && home != null) {
      paths.addAll([
        '$home/.bashrc',
        '$home/.bash_profile',
        '$home/.profile',
        '$home/.config/flutter/settings',
        '$home/.flutter',
      ]);
    } else if (isWindows && userProfile != null) {
      paths.addAll([
        '$userProfile\\.bashrc',
        '$userProfile\\AppData\\Local\\flutter\\settings',
        '$userProfile\\.flutter',
      ]);
    }

    return paths.toList();
  }

  static Future<Map<String, String>?> _validateFlutterPath(
    String flutterPath,
    String source,
  ) async {
    if (await Directory(flutterPath).exists()) {
      final flutterExe = path.join(
        flutterPath,
        'bin',
        isWindows ? 'flutter.bat' : 'flutter',
      );

      if (await File(flutterExe).exists()) {
        final result = await Process.run(flutterExe, ['--version']);
        if (result.exitCode == 0) {
          return {
            'FLUTTER_ROOT': flutterPath,
            'version': result.stdout.toString().trim(),
            'executable': flutterExe,
            'source': source,
          };
        }
      }
    }
    return null;
  }
}
