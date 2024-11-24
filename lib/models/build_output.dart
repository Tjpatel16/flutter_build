enum BuildOutputType {
  command,
  info,
  success,
  warning,
  error,
}

enum CommandStatus {
  running,
  success,
  failed,
  none,
}

class BuildOutput {
  final String text;
  final BuildOutputType type;
  final DateTime timestamp;
  final CommandStatus status;

  BuildOutput({
    required this.text,
    required this.type,
    DateTime? timestamp,
    this.status = CommandStatus.none,
  }) : timestamp = timestamp ?? DateTime.now();
}
