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
    final isEnabled = flutterInfoState.hasValue;

    return homeState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: TextWidget(
          error.toString(),
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      data: (state) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const TextWidget(
                  'Project Selection',
                  size: 18,
                  weight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: TextWidget(
                'Select your Flutter project directory',
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  state.projectName != null
                                      ? Icons.folder_open
                                      : Icons.create_new_folder_outlined,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextWidget(
                                    state.projectName ?? 'No project selected',
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            if (state.selectedProjectPath != null) ...[
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: TextWidget(
                                  state.selectedProjectPath ?? '',
                                  size: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: isEnabled
                            ? () {
                                final notifier =
                                    ref.read(homeProvider.notifier);
                                notifier.pickFlutterProject();
                              }
                            : null,
                        icon: const Icon(Icons.create_new_folder_outlined, size: 18),
                        label: TextWidget(
                          'Select',
                          weight: FontWeight.w600,
                          color: isEnabled
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
