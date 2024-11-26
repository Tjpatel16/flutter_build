import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../riverpod/home/home_provider.dart';
import '../../riverpod/flutter_info/flutter_info_provider.dart';
import 'text_widget.dart';

class ProjectSelection extends ConsumerWidget {
  const ProjectSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final flutterInfoState = ref.watch(flutterInfoProvider);
    final isEnabled =
        flutterInfoState.hasValue && flutterInfoState.value!.isFlutterAvailable;
    final colorScheme = Theme.of(context).colorScheme;

    return homeState.when(
      loading: () => const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stackTrace) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 16,
            color: colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextWidget(
              error.toString(),
              size: 16,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
      data: (state) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: state.selectedProjectPath != null && !state.isValidProject
              ? colorScheme.error.withOpacity(0.05)
              : colorScheme.surface,
          border: Border.all(
            color: state.selectedProjectPath != null && !state.isValidProject
                ? colorScheme.error
                : colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: state.selectedProjectPath != null &&
                                !state.isValidProject
                            ? colorScheme.error.withOpacity(0.1)
                            : colorScheme.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        state.selectedProjectPath != null &&
                                !state.isValidProject
                            ? Icons.folder_off_rounded
                            : state.projectName != null
                                ? Icons.folder_open_rounded
                                : Icons.create_new_folder_rounded,
                        size: 22,
                        color: state.selectedProjectPath != null &&
                                !state.isValidProject
                            ? colorScheme.error
                            : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        state.projectName ?? 'No project selected',
                        size: 16,
                        weight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            state.selectedProjectPath ??
                                'Select a Flutter project to begin',
                            size: 13,
                            color: colorScheme.onSurfaceVariant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (state.selectedProjectPath != null &&
                              !state.isValidProject) ...[
                            const SizedBox(height: 4),
                            TextWidget(
                              'Invalid Flutter project folder',
                              size: 13,
                              color: colorScheme.error,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: isEnabled
                      ? () =>
                          ref.read(homeProvider.notifier).pickFlutterProject()
                      : null,
                  icon: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: isEnabled
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withOpacity(0.38),
                  ),
                  label: TextWidget(
                    'Select Project',
                    size: 16,
                    weight: FontWeight.w500,
                    color: isEnabled
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withOpacity(0.38),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    minimumSize: const Size(140, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: isEnabled
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
