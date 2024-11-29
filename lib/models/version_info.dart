class VersionInfo {
  final String version;
  final String buildNumber;

  const VersionInfo({
    required this.version,
    required this.buildNumber,
  });

  /// Creates a default version info
  factory VersionInfo.defaultInfo() {
    return const VersionInfo(
      version: '0.0.0',
      buildNumber: '1',
    );
  }

  @override
  String toString() => 'v$version+$buildNumber';
}
