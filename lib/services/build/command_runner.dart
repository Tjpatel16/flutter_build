import 'dart:io';
import 'dart:convert';
import '../../models/build_output.dart';

class CommandRunner {
  static Process? _currentProcess;

  static Future<void> run(
    String command,
    List<String> arguments,
    String workingDirectory,
    void Function(String output, BuildOutputType type) addOutput,
  ) async {
    _currentProcess = await Process.start(
      command,
      arguments,
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    // Log the command being executed
    addOutput('\$ $command ${arguments.join(' ')}\n', BuildOutputType.command);

    // Handle stdout
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        _currentProcess!.stdout.transform(utf8.decoder).listen(
          (data) async {
            if (data.toLowerCase().contains('success') ||
                data.toLowerCase().contains('built')) {
              addOutput(data.trim(), BuildOutputType.success);
            } else if (data.toLowerCase().contains('warning')) {
              addOutput(data.trim(), BuildOutputType.warning);
            } else if (data.toLowerCase().contains('error')) {
              addOutput(data.trim(), BuildOutputType.error);
            } else {
              addOutput(data.trim(), BuildOutputType.info);
            }
          },
        );
      },
    );

    // Handle stderr
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        _currentProcess!.stderr.transform(utf8.decoder).listen(
          (data) async {
            if (data.toLowerCase().contains('warning')) {
              addOutput(data.trim(), BuildOutputType.warning);
            } else {
              addOutput(data.trim(), BuildOutputType.error);
            }
          },
        );
      },
    );

    final exitCode = await _currentProcess!.exitCode;
    if (exitCode != 0) {
      addOutput(
        '\nProcess exited with code $exitCode\n',
        BuildOutputType.error,
      );
      throw Exception('Command failed with exit code $exitCode');
    }
  }

  static void stopCurrentProcess() {
    if (_currentProcess != null) {
      _currentProcess!.kill(ProcessSignal.sigterm);
      _currentProcess = null;
    }
  }
}
