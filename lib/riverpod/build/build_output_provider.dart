import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/build_output.dart';
import '../../services/build/build_manager.dart';
import '../../services/build/command_runner.dart';
import '../../utils/notification_utils.dart';
import '../home/home_provider.dart';

final buildOutputProvider =
    AsyncNotifierProvider<BuildOutputNotifier, List<BuildOutput>>(
  () => BuildOutputNotifier(),
);

class BuildOutputNotifier extends AsyncNotifier<List<BuildOutput>> {
  final List<BuildOutput> _output = [];

  @override
  Future<List<BuildOutput>> build() async {
    return _output;
  }

  void clear() {
    _output.clear();
    state = AsyncValue.data(_output);
  }

  void _addOutput(String text, BuildOutputType type) {
    final output = BuildOutput(
      text: text,
      type: type,
      status: type == BuildOutputType.command
          ? CommandStatus.running
          : CommandStatus.none,
    );
    _output.add(output);
    state = AsyncValue.data(_output);
  }

  void updateLastCommandStatus(CommandStatus status) {
    for (var i = _output.length - 1; i >= 0; i--) {
      if (_output[i].type == BuildOutputType.command) {
        _output[i] = BuildOutput(
          text: _output[i].text,
          type: _output[i].type,
          timestamp: _output[i].timestamp,
          status: status,
        );
        state = AsyncValue.data(_output);
        break;
      }
    }
  }

  Future<void> startBuild() async {
    _output.clear();

    final homeState = ref.read(homeProvider);

    if (!homeState.hasValue) {
      state =
          AsyncValue.error('Home state not initialized', StackTrace.current);
      return;
    }

    try {
      state = const AsyncValue.loading();
      _output.clear();

      final buildManager = BuildManager(ref, _addOutput);
      await buildManager.validateAndStartBuild();

      state = AsyncValue.data(_output);
    } catch (error) {
      NotificationUtils.showError(
        message: 'Build failed: ${error.toString()}',
      );
      // state = AsyncValue.error(error, StackTrace.current);
    }
  }

  void stopBuild() {
    CommandRunner.stopCurrentProcess();
    _addOutput('🛑 Build process stopped by user\n', BuildOutputType.info);
    updateLastCommandStatus(CommandStatus.failed);
  }
}
