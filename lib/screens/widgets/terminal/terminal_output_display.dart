import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/build_output.dart';
import 'command_status_indicator.dart';

class TerminalOutputDisplay extends StatelessWidget {
  final List<BuildOutput> outputs;
  final ScrollController scrollController;

  const TerminalOutputDisplay({
    super.key,
    required this.outputs,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (outputs.isEmpty) {
      return Center(
        child: Text(
          'No output yet. Start a build to see the process here.',
          style: GoogleFonts.firaCode(
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: outputs.length,
      itemBuilder: (context, index) {
        final output = outputs[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _buildOutputLine(context, output),
        );
      },
    );
  }

  Widget _buildOutputLine(BuildContext context, BuildOutput output) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SelectableText(
            output.text,
            style: GoogleFonts.firaCode(
              color: _getOutputColor(output.type),
            ),
          ),
        ),
        if (output.type == BuildOutputType.command)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CommandStatusIndicator(status: output.status),
          ),
      ],
    );
  }

  Color _getOutputColor(BuildOutputType type) {
    switch (type) {
      case BuildOutputType.command:
        return const Color(0xFF569CD6); // Light blue
      case BuildOutputType.info:
        return Colors.white70;
      case BuildOutputType.success:
        return const Color(0xFF4EC9B0); // Teal
      case BuildOutputType.warning:
        return const Color(0xFFCE9178); // Light orange
      case BuildOutputType.error:
        return const Color(0xFFF44747); // Light red
    }
  }
}
