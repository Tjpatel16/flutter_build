import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/build_output.dart';
import '../../../riverpod/build/build_output_provider.dart';
import '../text_widget.dart';
import 'terminal_output_display.dart';

class TerminalView extends ConsumerStatefulWidget {
  const TerminalView({super.key});

  @override
  ConsumerState<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends ConsumerState<TerminalView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildStatusIndicator(AsyncValue<List<BuildOutput>> buildState) {
    if (buildState.value == null || buildState.value!.isEmpty) {
      return const SizedBox(width: 28); // Consistent spacing when empty
    }

    // Check if any command is currently running
    final hasRunningCommand = buildState.value!.any(
      (output) => output.status == CommandStatus.running,
    );

    // Analyze all outputs for status
    final hasErrors = buildState.value!.any(
      (output) =>
          output.type == BuildOutputType.error ||
          output.status == CommandStatus.failed,
    );

    return Row(
      children: [
        if (hasRunningCommand) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => ref.read(buildOutputProvider.notifier).stopBuild(),
            icon: const Icon(
              Icons.stop,
              color: Colors.red,
              size: 20,
            ),
            tooltip: 'Stop build',
          ),
        ] else ...[
          if (hasErrors)
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 20,
            )
          else
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final buildState = ref.watch(buildOutputProvider);

    // Scroll to bottom when new output is added
    if (buildState.hasValue && buildState.value!.isNotEmpty) {
      _scrollToBottom();
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal_sharp,
                  size: 20,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                const TextWidget(
                  'Build Output',
                  size: 14,
                  weight: FontWeight.w500,
                  color: Colors.white70,
                ),
                const Spacer(),
                _buildStatusIndicator(buildState),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    ref.read(buildOutputProvider.notifier).clear();
                  },
                  icon: const Icon(
                    Icons.clear_all,
                    color: Colors.white70,
                    size: 20,
                  ),
                  tooltip: 'Clear terminal',
                ),
              ],
            ),
          ),
          Expanded(
            child: buildState.when(
              data: (outputs) => TerminalOutputDisplay(
                outputs: outputs,
                scrollController: _scrollController,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                ),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
