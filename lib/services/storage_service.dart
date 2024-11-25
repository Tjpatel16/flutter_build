import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_history.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String settingsBoxName = 'settings';
  static const String historyBoxName = 'project_history';

  static Box? _settingsBox;
  static Box<ProjectHistory>? _historyBox;

  static Box? get settings => _settingsBox;
  static Box<ProjectHistory>? get history => _historyBox;

  static Future<void> initialize() async {
    try {
      debugPrint('Initializing Hive...');
      await Hive.initFlutter();
      debugPrint('Hive initialized successfully');

      // Register adapters
      if (!Hive.isAdapterRegistered(ProjectHistoryAdapter().typeId)) {
        debugPrint('Registering ProjectHistory adapter...');
        Hive.registerAdapter(ProjectHistoryAdapter());
      }

      try {
        // Open boxes
        if (!Hive.isBoxOpen(settingsBoxName)) {
          debugPrint('Opening settings box...');
          _settingsBox = await Hive.openBox(settingsBoxName);
        } else {
          _settingsBox = Hive.box(settingsBoxName);
        }

        if (!Hive.isBoxOpen(historyBoxName)) {
          debugPrint('Opening history box...');
          _historyBox = await Hive.openBox<ProjectHistory>(historyBoxName);
        } else {
          _historyBox = Hive.box<ProjectHistory>(historyBoxName);
        }
        debugPrint('All boxes opened successfully');
      } catch (e) {
        debugPrint('Error opening boxes: $e');
        // If there's an error opening boxes, try to delete and recreate them
        try {
          debugPrint('Attempting to delete and recreate boxes...');
          await Hive.deleteBoxFromDisk(settingsBoxName);
          await Hive.deleteBoxFromDisk(historyBoxName);
          
          _settingsBox = await Hive.openBox(settingsBoxName);
          _historyBox = await Hive.openBox<ProjectHistory>(historyBoxName);
          debugPrint('Boxes recreated successfully');
        } catch (e) {
          debugPrint('Failed to recreate boxes: $e');
          // Make boxes nullable and continue
          _settingsBox = null;
          _historyBox = null;
        }
      }
    } catch (e) {
      debugPrint('Error in storage initialization: $e');
      // Make boxes nullable and continue
      _settingsBox = null;
      _historyBox = null;
    }
  }

  static Future<void> clearAll() async {
    try {
      await _settingsBox?.clear();
      await _historyBox?.clear();
    } catch (e) {
      debugPrint('Error clearing boxes: $e');
    }
  }

  static Future<void> close() async {
    try {
      await _settingsBox?.close();
      await _historyBox?.close();
    } catch (e) {
      debugPrint('Error closing boxes: $e');
    }
  }

  // Settings methods
  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox?.put(key, value);
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox?.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> removeSetting(String key) async {
    await _settingsBox?.delete(key);
  }
}
