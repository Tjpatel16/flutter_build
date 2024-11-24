import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';

enum BuildStatus {
  idle,
  cleaning,
  building,
  finished,
  error,
}

class BuildProcessState {
  final BuildStatus status;
  final String output;
  final String error;

  BuildProcessState({
    this.status = BuildStatus.idle,
    this.output = '',
    this.error = '',
  });

  BuildProcessState copyWith({
    BuildStatus? status,
    String? output,
    String? error,
  }) {
    return BuildProcessState(
      status: status ?? this.status,
      output: output ?? this.output,
      error: error ?? this.error,
    );
  }
}

final buildProcessProvider =
    StateNotifierProvider<BuildProcessNotifier, BuildProcessState>((ref) {
  return BuildProcessNotifier();
});

class BuildProcessNotifier extends StateNotifier<BuildProcessState> {
  BuildProcessNotifier() : super(BuildProcessState());

  void reset() {
    Future.microtask(() {
      state = BuildProcessState();
    });
  }

  Future<void> cleanProject(String projectPath) async {
    try {
      // Set initial cleaning state
      state = state.copyWith(
        status: BuildStatus.cleaning,
        output: 'Starting Flutter clean...\n\nProject path: $projectPath\n\n',
        error: '',
      );

      const flutterPath = '/Users/tj/Flutter/flutter/bin/flutter';
      final shell = Shell(
          workingDirectory: projectPath,
          throwOnError: false // Don't throw on non-zero exit codes
          );

      // First repair Flutter
      state = state.copyWith(
        output: '${state.output}Repairing Flutter installation...\n\n',
      );

      await shell.run('$flutterPath pub cache repair');

      // Run flutter clean command
      state = state.copyWith(
        output: '${state.output}Running: flutter clean\n\n',
      );

      final result = await shell.run('$flutterPath clean');

      // Process command output
      final output = result.map((r) => r.stdout.toString()).join('\n');
      final error = result.map((r) => r.stderr.toString()).join('\n');

      if (error.isNotEmpty && error.toLowerCase().contains('error')) {
        // Handle error case
        state = state.copyWith(
          status: BuildStatus.error,
          output: state.output + output,
          error: 'Error during flutter clean:\n$error',
        );
      } else {
        // Handle success case
        state = state.copyWith(
          status: BuildStatus.finished,
          output:
              '${state.output}$output\n\nFlutter clean completed successfully!',
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      state = state.copyWith(
        status: BuildStatus.error,
        error: 'Failed to run flutter clean:\n${e.toString()}',
      );
    }
  }
}
