import 'package:hive/hive.dart';

part 'project_history.g.dart';

@HiveType(typeId: 0)
class ProjectHistory extends HiveObject {
  @HiveField(0)
  final String path;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime lastAccessed;

  ProjectHistory({
    required this.path,
    required this.name,
    required this.lastAccessed,
  });
}
