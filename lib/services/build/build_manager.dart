import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/build_output.dart';
import '../../riverpod/home/home_provider.dart';
import '../../riverpod/home/home_state.dart';
import 'build_output_formatter.dart';
import 'build_service.dart';

class BuildManager {
  final Ref ref;
  final void Function(String text, BuildOutputType type) addOutput;
  final BuildOutputFormatter _outputFormatter;
  final BuildService _buildService;

  BuildManager(this.ref, this.addOutput)
      : _outputFormatter = BuildOutputFormatter(addOutput),
        _buildService = BuildService(ref, addOutput);

  Future<void> validateAndStartBuild() async {
    final homeState = ref.read(homeProvider);
    _validateHomeState(homeState);

    final homeData = homeState.value!;
    _validateProject(homeData);

    _outputFormatter.printInitialBuildInfo(homeData);
    await _buildService.startBuild();
  }

  void _validateHomeState(AsyncValue<HomeState> homeState) {
    if (!homeState.hasValue) {
      throw Exception('Home state not initialized');
    }
  }

  void _validateProject(HomeState homeData) {
    if (homeData.selectedProjectPath == null || !homeData.isValidProject) {
      throw Exception('No valid Flutter project selected');
    }
  }
}
