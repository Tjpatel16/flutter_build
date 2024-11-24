import 'package:flutter/foundation.dart';

@immutable
class HomeState {
  final String? selectedProjectPath;
  final String? projectName;
  final bool isValidProject;

  const HomeState({
    this.selectedProjectPath,
    this.projectName,
    this.isValidProject = false,
  });

  HomeState copyWith({
    String? selectedProjectPath,
    String? projectName,
    bool? isValidProject,
  }) {
    return HomeState(
      selectedProjectPath: selectedProjectPath ?? this.selectedProjectPath,
      projectName: projectName ?? this.projectName,
      isValidProject: isValidProject ?? this.isValidProject,
    );
  }
}
