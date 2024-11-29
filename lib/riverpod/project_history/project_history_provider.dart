import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/project_history.dart';
import '../../services/history_service.dart';

final projectHistoryProvider =
    AsyncNotifierProvider<ProjectHistoryNotifier, ProjectHistoryState>(
        () => ProjectHistoryNotifier());

class ProjectHistoryState {
  final List<ProjectHistory> recentProjects;

  const ProjectHistoryState({
    required this.recentProjects,
  });
}

class ProjectHistoryNotifier extends AsyncNotifier<ProjectHistoryState> {
  @override
  Future<ProjectHistoryState> build() async {
    final projects = HistoryService.getProjects();
    debugPrint('ProjectHistoryNotifier: Retrieved ${projects.length} projects');
    return ProjectHistoryState(recentProjects: projects);
  }

  Future<void> addProject(String projectPath) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await HistoryService.addProject(projectPath);
      return ProjectHistoryState(
        recentProjects: HistoryService.getProjects(),
      );
    });
  }

  Future<void> removeProject(String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await HistoryService.removeProject(path);
      return ProjectHistoryState(
        recentProjects: HistoryService.getProjects(),
      );
    });
  }

  Future<void> clearHistory() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await HistoryService.clearHistory();
      return const ProjectHistoryState(recentProjects: []);
    });
  }
}
