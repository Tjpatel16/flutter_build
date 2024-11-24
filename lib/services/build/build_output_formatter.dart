import '../../models/build_output.dart';
import '../../riverpod/home/home_state.dart';

class BuildOutputFormatter {
  final void Function(String text, BuildOutputType type) addOutput;

  const BuildOutputFormatter(this.addOutput);

  void printInitialBuildInfo(HomeState homeData) {
    addOutput('🚀 Build Process Started', BuildOutputType.info);
    addOutput(
      '📂 Project: ${homeData.projectName ?? 'Flutter Project'}',
      BuildOutputType.info,
    );
    addOutput(
      '📍 Location: ${homeData.selectedProjectPath}',
      BuildOutputType.info,
    );
    addOutput(
      '⏱️ Time: ${DateTime.now().toString()}\n',
      BuildOutputType.info,
    );
  }
}
