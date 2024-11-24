
import 'package:flutter/material.dart';
import '../../../models/build_output.dart';

class CommandStatusIndicator extends StatelessWidget {
  final CommandStatus status;
  final double size;

  const CommandStatusIndicator({
    super.key,
    required this.status,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case CommandStatus.running:
        return SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      case CommandStatus.success:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: size,
        );
      case CommandStatus.failed:
        return Icon(
          Icons.error,
          color: Colors.red,
          size: size,
        );
      case CommandStatus.none:
        return const SizedBox.shrink();
    }
  }
}
