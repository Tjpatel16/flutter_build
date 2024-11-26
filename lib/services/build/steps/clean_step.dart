import 'dart:io';

import '../../../models/build_output.dart';
import '../build_step.dart';
import '../command_runner.dart';
import '../flutter_executable.dart';

class CleanStep extends BuildStep {
  CleanStep(super.ref);

  @override
  Future<void> execute({
    required String workingDir,
    required void Function(String output, BuildOutputType type) addOutput,
  }) async {
    final flutterExe = await FlutterExecutable.getPath();

    addOutput('${'>' * 50}\n', BuildOutputType.info);
    addOutput('🧹 Step 1/3: Cleaning project...', BuildOutputType.info);
    await CommandRunner.run(flutterExe, ['clean'], workingDir, addOutput);
    addOutput('\n', BuildOutputType.info);
    addOutput('✅ Clean completed successfully\n', BuildOutputType.success);
    addOutput('${'>' * 50}\n', BuildOutputType.info);
  }
}
