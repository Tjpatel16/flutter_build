class FlutterInfoState {
  final String flutterVersion;
  final String dartVersion;

  const FlutterInfoState({
    required this.flutterVersion,
    required this.dartVersion,
  });

  FlutterInfoState copyWith({
    String? flutterVersion,
    String? dartVersion,
  }) {
    return FlutterInfoState(
      flutterVersion: flutterVersion ?? this.flutterVersion,
      dartVersion: dartVersion ?? this.dartVersion,
    );
  }
}
