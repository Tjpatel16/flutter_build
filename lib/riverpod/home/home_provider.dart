import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import '../../services/storage_service.dart';
import '../build/app_build_provider.dart';
import '../build/build_process_provider.dart';
import '../build/build_output_provider.dart';
import '../build/app_mode_provider.dart';
import '../version/version_provider.dart';
import '../flutter_info/flutter_info_provider.dart';
import '../project_history/project_history_provider.dart';
import 'home_state.dart';

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    try {
      debugPrint('Initializing storage service...');
      await StorageService.initialize();
      debugPrint('Storage service initialized');
      return const HomeState();
    } catch (e) {
      debugPrint('Error in home provider build: $e');
      return const HomeState();
    }
  }

  Future<void> pickFlutterProject() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      await _validateAndSetProject(selectedDirectory);
    }
  }

  Future<void> selectFromHistory(String projectPath) async {
    await _validateAndSetProject(projectPath);
  }

  Future<void> _validateAndSetProject(String projectPath) async {
    state = const AsyncLoading();

    try {
      // Reset all configurations before setting new project
      await _resetConfigurations();

      await Future.delayed(const Duration(milliseconds: 700));

      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final libDir = Directory(path.join(projectPath, 'lib'));

      final isValid = await pubspecFile.exists() && await libDir.exists();
      final projectName = path.basename(projectPath);

      if (isValid) {
        await ref
            .read(projectHistoryProvider.notifier)
            .addProject(projectPath);
        await ref.read(versionInfoProvider.notifier).loadVersion(projectPath);
      }

      state = AsyncData(HomeState(
        selectedProjectPath: projectPath,
        projectName: projectName,
        isValidProject: isValid,
      ));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> _resetConfigurations() async {
    // Reset build process state
    ref.read(buildProcessProvider.notifier).reset();

    // Reset build output
    ref.read(buildOutputProvider.notifier).clear();

    // Reset app mode
    ref.invalidate(appBuildTypeProvider);

    // Reset app mode
    ref.invalidate(appModeTypeProvider);

    // Reset version state
    ref.invalidate(versionInfoProvider);

    // Reset flutter info
    ref.invalidate(flutterInfoProvider);
  }
}
