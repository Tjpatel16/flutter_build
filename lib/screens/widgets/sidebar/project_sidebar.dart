import 'package:flutter/material.dart';
import '../../widgets/theme/theme_toggle_button.dart';
import 'project_history_sidebar.dart';
import 'version_info.dart';

class ProjectSidebar extends StatelessWidget {
  const ProjectSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: const Column(
        children: [
          Expanded(child: ProjectHistorySidebar()),
          ThemeToggleButton(),
          VersionInfo(),
        ],
      ),
    );
  }
}
