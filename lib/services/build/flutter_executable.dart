import 'dart:io';
import 'package:path/path.dart' as path;
import '../flutter_path_service.dart';

class FlutterExecutable {
  static Future<String> getPath() async {
    final flutterInfo = await FlutterPathService().getFlutterInfo();
    if (!flutterInfo.containsKey('FLUTTER_ROOT')) {
      throw Exception('Flutter SDK not found');
    }

    return path.join(
      flutterInfo['FLUTTER_ROOT']!,
      'bin',
      Platform.isWindows ? 'flutter.bat' : 'flutter',
    );
  }
}
