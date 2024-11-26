import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/build_output.dart';
import '../../riverpod/home/home_provider.dart';
import '../../riverpod/build/build_output_provider.dart';
import 'steps/clean_step.dart';
import 'steps/dependencies_step.dart';
import 'steps/build_execution_step.dart';
import 'steps/version_update_step.dart';

class BuildService {
  final Ref ref;
  final void Function(String output, BuildOutputType type) addOutput;

  BuildService(this.ref, this.addOutput);

  void _updateLastCommandStatus(CommandStatus status) {
    final notifier = ref.read(buildOutputProvider.notifier);
    notifier.updateLastCommandStatus(status);
  }

  Future<void> startBuild() async {
    final homeState = ref.read(homeProvider);

    if (!homeState.hasValue) {
      throw Exception('Home state not initialized');
    }

    final homeData = homeState.value!;
    final workingDir = homeData.selectedProjectPath!;

    addOutput('=' * 50, BuildOutputType.info);
    addOutput('🚀 Starting build process...', BuildOutputType.info);
    addOutput('=' * 50, BuildOutputType.info);

    final steps = [
      VersionUpdateStep(ref),
      CleanStep(ref),
      DependenciesStep(ref),
      BuildExecutionStep(ref),
    ];

    try {
      for (final step in steps) {
        try {
          await step.execute(
            workingDir: workingDir,
            addOutput: addOutput,
          );
          _updateLastCommandStatus(CommandStatus.success);
        } catch (error) {
          _updateLastCommandStatus(CommandStatus.failed);
          rethrow;
        }
      }

      await _printBuildSuccess();
    } catch (error) {
      await _printBuildFailure(error);
      rethrow;
    }
  }

  Future<void> _printBuildSuccess() async {
    addOutput('\n${'=' * 50}', BuildOutputType.success);
    addOutput(
      '✨ Build Process Completed Successfully!',
      BuildOutputType.success,
    );
    addOutput(
      '🕒 Finished at: ${DateTime.now().toString()}',
      BuildOutputType.info,
    );
    addOutput('${'=' * 50}\n', BuildOutputType.success);
  }

  Future<void> _printBuildFailure(Object error) async {
    addOutput('\n${'=' * 50}', BuildOutputType.error);
    addOutput(
      '❌ Build Process Failed!',
      BuildOutputType.error,
    );
    addOutput(
      'Error: $error',
      BuildOutputType.error,
    );
    addOutput(
      '⏱️ Failed at: ${DateTime.now().toString()}',
      BuildOutputType.error,
    );
    addOutput('${'=' * 50}\n', BuildOutputType.error);
  }
}
