import '../models/project_history.dart';
import 'storage_service.dart';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  Future<void> addProject(String path, String name) async {
    final box = StorageService.history;
    // Check if project already exists
    final existingIndex = box.values.toList().indexWhere((p) => p.path == path);
    if (existingIndex != -1) {
      // Update the project with new lastAccessed time while keeping its position
      final existing = box.getAt(existingIndex);
      if (existing != null) {
        final updatedProject = ProjectHistory(
          path: existing.path,
          name: existing.name,
          lastAccessed: DateTime.now(),
        );
        await box.putAt(existingIndex, updatedProject);
      }
      return;
    }

    // Add new project to the end of the list
    final project = ProjectHistory(
      path: path,
      name: name,
      lastAccessed: DateTime.now(),
    );
    await box.add(project);
  }

  List<ProjectHistory> getRecentProjects() {
    final projects = StorageService.history.values.toList();
    // Sort by last accessed time, most recent first
    // projects.sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
    return projects.reversed.toList();
  }

  Future<void> removeProject(String path) async {
    final box = StorageService.history;
    final index = box.values.toList().indexWhere((p) => p.path == path);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  Future<void> clearHistory() async {
    await StorageService.history.clear();
  }
}
