import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_history.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String settingsBoxName = 'settings';
  static const String historyBoxName = 'project_history';

  static late Box _settingsBox;
  static late Box<ProjectHistory> _historyBox;

  static Box get settings => _settingsBox;
  static Box<ProjectHistory> get history => _historyBox;

  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();
    } catch (e) {
      // Hive is already initialized, continue
    }

    // Register adapters
    if (!Hive.isAdapterRegistered(ProjectHistoryAdapter().typeId)) {
      Hive.registerAdapter(ProjectHistoryAdapter());
    }

    // Open boxes
    if (!Hive.isBoxOpen(settingsBoxName)) {
      _settingsBox = await Hive.openBox(settingsBoxName);
    } else {
      _settingsBox = Hive.box(settingsBoxName);
    }

    if (!Hive.isBoxOpen(historyBoxName)) {
      _historyBox = await Hive.openBox<ProjectHistory>(historyBoxName);
    } else {
      _historyBox = Hive.box<ProjectHistory>(historyBoxName);
    }
  }

  static Future<void> clearAll() async {
    await _settingsBox.clear();
    await _historyBox.clear();
  }

  static Future<void> close() async {
    await _settingsBox.close();
    await _historyBox.close();
  }

  // Settings methods
  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> removeSetting(String key) async {
    await _settingsBox.delete(key);
  }
}
