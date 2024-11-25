import 'dart:io';

import 'package:flutter/material.dart';

import '../models/project_history.dart';
import '../services/storage_service.dart';

class HistoryService {
  static Future<void> addProject(String path) async {
    try {
      final box = StorageService.history;
      if (box == null) return;

      final existingIndex = box.values?.toList().indexWhere((p) => p.path == path) ?? -1;

      if (existingIndex != -1) {
        // Update existing project
        final existing = box.getAt(existingIndex);
        if (existing != null) {
          final updatedProject = ProjectHistory(
            path: existing.path,
            lastAccessed: DateTime.now(),
            name: existing.name,
          );
          await box.putAt(existingIndex, updatedProject);
        }
      } else {
        // Add new project
        final project = ProjectHistory(
          path: path,
          lastAccessed: DateTime.now(),
          name: path.split(Platform.pathSeparator).last,
        );
        await box.add(project);
      }
    } catch (e) {
      debugPrint('Error adding project to history: $e');
    }
  }

  static List<ProjectHistory> getProjects() {
    try {
      final projects = StorageService.history?.values?.toList() ?? [];
      return projects..sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
    } catch (e) {
      debugPrint('Error getting projects from history: $e');
      return [];
    }
  }

  static Future<void> removeProject(String path) async {
    try {
      final box = StorageService.history;
      if (box == null) return;

      final index = box.values?.toList().indexWhere((p) => p.path == path) ?? -1;
      if (index != -1) {
        await box.deleteAt(index);
      }
    } catch (e) {
      debugPrint('Error removing project from history: $e');
    }
  }

  static Future<void> clearHistory() async {
    try {
      await StorageService.history?.clear();
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }
}
