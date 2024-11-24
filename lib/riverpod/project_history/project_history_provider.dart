import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/history_service.dart';
import '../../services/storage_service.dart';
import 'project_history_state.dart';

final historyServiceProvider = Provider((ref) => HistoryService());

final projectHistoryProvider = AsyncNotifierProvider<ProjectHistoryNotifier, ProjectHistoryState>(() {
  return ProjectHistoryNotifier();
});

class ProjectHistoryNotifier extends AsyncNotifier<ProjectHistoryState> {
  late final HistoryService _historyService;

  @override
  Future<ProjectHistoryState> build() async {
    await StorageService.initialize();
    _historyService = ref.read(historyServiceProvider);
    return ProjectHistoryState(recentProjects: _historyService.getRecentProjects());
  }

  Future<void> addProject(String projectPath, String projectName) async {
    await _historyService.addProject(projectPath, projectName);
    state = AsyncData(state.value!.copyWith(
      recentProjects: _historyService.getRecentProjects(),
    ));
  }

  Future<void> removeProject(String path) async {
    await _historyService.removeProject(path);
    state = AsyncData(state.value!.copyWith(
      recentProjects: _historyService.getRecentProjects(),
    ));
  }

  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    state = AsyncData(state.value!.copyWith(
      recentProjects: [],
    ));
  }
}
