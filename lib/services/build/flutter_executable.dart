import 'dart:io';
import 'package:path/path.dart' as path;
import '../flutter_path_service.dart';

class FlutterExecutable {
  static String? _cachedPath;

  static Future<String> getPath() async {
    if (_cachedPath != null) {
      return _cachedPath!;
    }

    final flutterInfo = await FlutterPathService().getFlutterInfo();
    if (!flutterInfo.containsKey('FLUTTER_ROOT')) {
      throw Exception('Flutter SDK not found');
    }

    _cachedPath = path.join(
      flutterInfo['FLUTTER_ROOT']!,
      'bin',
      Platform.isWindows ? 'flutter.bat' : 'flutter',
    );

    return _cachedPath!;
  }
}
