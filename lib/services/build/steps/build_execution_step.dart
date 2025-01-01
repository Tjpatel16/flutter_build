import '../../../models/build_output.dart';
import '../../../riverpod/build/advance_option_provider.dart';
import '../../../riverpod/build/app_build_provider.dart';
import '../../../riverpod/build/app_build_type.dart';
import '../../../riverpod/build/app_mode_provider.dart';
import '../../../riverpod/build/app_mode_type.dart';
import '../build_step.dart';
import '../command_runner.dart';
import '../flutter_executable.dart';

class BuildExecutionStep extends BuildStep {
  BuildExecutionStep(super.ref);

  @override
  Future<void> execute({
    required String workingDir,
    required void Function(String output, BuildOutputType type) addOutput,
  }) async {
    final buildType = ref.read(appBuildTypeProvider);
    if (buildType == null) {
      throw Exception('Build type not selected');
    }

    final flutterExe = await FlutterExecutable.getPath();

    final appMode = ref.read(appModeTypeProvider);
    final webRender = ref.read(webRenderProvider);

    addOutput(
        '🔨 Step 3/4: Building ${buildType.title}...', BuildOutputType.info);

    final List<String> buildCommand = ['build', buildType.command];
    if (appMode != null) {
      buildCommand.add(appMode.flag);
    }
    if (buildType == AppBuildType.webApp && appMode == AppModeType.release) {
      if (webRender != null) {
        buildCommand.add(webRender.flag);
      }
    }

    await CommandRunner.run(flutterExe, buildCommand, workingDir, addOutput);
  }
}
