class FlutterInfoState {
  final String flutterVersion;
  final String dartVersion;
  final bool isFlutterAvailable;

  const FlutterInfoState({
    required this.flutterVersion,
    required this.dartVersion,
    required this.isFlutterAvailable,
  });

  FlutterInfoState copyWith({
    String? flutterVersion,
    String? dartVersion,
    bool? isFlutterAvailable,
  }) {
    return FlutterInfoState(
      flutterVersion: flutterVersion ?? this.flutterVersion,
      dartVersion: dartVersion ?? this.dartVersion,
      isFlutterAvailable: isFlutterAvailable ?? this.isFlutterAvailable,
    );
  }
}
