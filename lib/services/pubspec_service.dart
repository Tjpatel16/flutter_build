import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class PubspecInfo {
  final String name;
  final String version;
  final String buildNumber;

  PubspecInfo({
    required this.name,
    required this.version,
    required this.buildNumber,
  });

  String get fullVersion => '$version+$buildNumber';

  factory PubspecInfo.fromYaml(String yamlContent) {
    final yaml = loadYaml(yamlContent) as Map;
    final versionParts = (yaml['version']?.toString() ?? '1.0.0+1').split('+');
    
    return PubspecInfo(
      name: yaml['name']?.toString() ?? '',
      version: versionParts[0],
      buildNumber: versionParts.length > 1 ? versionParts[1] : '1',
    );
  }
}

class PubspecService {
  static final PubspecService _instance = PubspecService._internal();
  factory PubspecService() => _instance;
  PubspecService._internal();

  File? _pubspecFile;
  PubspecInfo? _cachedInfo;

  void initialize(String projectPath) {
    _pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
    _cachedInfo = null;
  }

  bool get isInitialized => _pubspecFile != null;

  Future<bool> exists() async {
    _assertInitialized();
    return _pubspecFile!.exists();
  }

  Future<PubspecInfo> getInfo() async {
    _assertInitialized();
    
    if (_cachedInfo != null) {
      return _cachedInfo!;
    }

    if (!await exists()) {
      throw Exception('pubspec.yaml not found');
    }

    final content = await _pubspecFile!.readAsString();
    _cachedInfo = PubspecInfo.fromYaml(content);
    return _cachedInfo!;
  }

  Future<void> updateVersion({String? version, String? buildNumber}) async {
    _assertInitialized();
    
    final currentInfo = await getInfo();
    final newVersion = version ?? currentInfo.version;
    final newBuildNumber = buildNumber ?? currentInfo.buildNumber;

    final content = await _pubspecFile!.readAsString();
    final lines = content.split('\n');
    bool versionUpdated = false;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith('version:')) {
        lines[i] = 'version: $newVersion+$newBuildNumber';
        versionUpdated = true;
        break;
      }
    }

    if (!versionUpdated) {
      throw Exception('Version line not found in pubspec.yaml');
    }

    await _pubspecFile!.writeAsString(lines.join('\n'));
    _cachedInfo = null; // Clear cache after update
  }

  void _assertInitialized() {
    if (!isInitialized) {
      throw Exception('PubspecService not initialized. Call initialize() first.');
    }
  }
}
