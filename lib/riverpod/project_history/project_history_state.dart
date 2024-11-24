import 'package:flutter/foundation.dart';
import '../../models/project_history.dart';

@immutable
class ProjectHistoryState {
  final List<ProjectHistory> recentProjects;

  const ProjectHistoryState({
    this.recentProjects = const [],
  });

  ProjectHistoryState copyWith({
    List<ProjectHistory>? recentProjects,
  }) {
    return ProjectHistoryState(
      recentProjects: recentProjects ?? this.recentProjects,
    );
  }
}
