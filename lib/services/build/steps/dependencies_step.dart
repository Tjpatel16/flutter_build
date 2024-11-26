import '../../../models/build_output.dart';
import '../build_step.dart';
import '../command_runner.dart';
import '../flutter_executable.dart';

class DependenciesStep extends BuildStep {
  DependenciesStep(super.ref);

  @override
  Future<void> execute({
    required String workingDir,
    required void Function(String output, BuildOutputType type) addOutput,
  }) async {
    final flutterExe = await FlutterExecutable.getPath();
    
    addOutput('📦 Step 2/3: Updating dependencies...', BuildOutputType.info);
    await CommandRunner.run(flutterExe, ['pub', 'get'], workingDir, addOutput);
    addOutput('\n', BuildOutputType.info);
    addOutput('✅ Dependencies updated successfully\n', BuildOutputType.success);
    addOutput('${'>' * 50}\n', BuildOutputType.info);
  }
}
