import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/project_history.dart';
import '../../../riverpod/home/home_provider.dart';
import '../../../riverpod/project_history/project_history_provider.dart';
import '../../../riverpod/flutter_info/flutter_info_provider.dart';
import '../../../utils/field_constant.dart';
import '../text_widget.dart';
import '../../../utils/notification_utils.dart';

class ProjectHistorySidebar extends ConsumerWidget {
  const ProjectHistorySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(projectHistoryProvider);

    return historyState.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              TextWidget(
                error.toString(),
                textAlign: TextAlign.center,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
      ),
      data: (state) {
        if (state.recentProjects.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 48,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  TextWidget(
                    FieldConstant.noProjectHistory,
                    textAlign: TextAlign.center,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    'Select a Flutter project to get started',
                    size: 12,
                    textAlign: TextAlign.center,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.7),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const TextWidget(
                        FieldConstant.recentProjects,
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Tooltip(
                    message: FieldConstant.clearHistory,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          ref
                              .read(projectHistoryProvider.notifier)
                              .clearHistory();
                          NotificationUtils.showInfo(
                            message: 'Project history cleared',
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_outline,
                            size: 20,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                itemCount: state.recentProjects.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final project = state.recentProjects[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _ProjectHistoryTile(
                      project: project,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectHistoryTile extends ConsumerWidget {
  final ProjectHistory project;

  const _ProjectHistoryTile({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final isSelected =
        homeState.valueOrNull?.selectedProjectPath == project.path;
    final flutterInfoState = ref.watch(flutterInfoProvider);
    final isEnabled = flutterInfoState.hasValue;

    return Tooltip(
      message: project.path,
      waitDuration: const Duration(milliseconds: 500),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isEnabled
                ? () {
                    ref
                        .read(homeProvider.notifier)
                        .selectFromHistory(project.path);
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 20,
                    color: isEnabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          project.name,
                          size: 14,
                          weight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isEnabled
                              ? null
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                        ),
                        const SizedBox(height: 2),
                        TextWidget(
                          _shortenPath(project.path),
                          size: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withOpacity(isEnabled ? 0.8 : 0.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: 'Remove from history',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            ref
                                .read(projectHistoryProvider.notifier)
                                .removeProject(project.path);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(isEnabled ? 0.6 : 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _shortenPath(String path) {
    final parts = path.split('/');
    if (parts.length <= 2) return path;

    // Only show last two parts
    final lastTwo = parts.sublist(parts.length - 2);
    return '.../${lastTwo.join('/')}';
  }
}
