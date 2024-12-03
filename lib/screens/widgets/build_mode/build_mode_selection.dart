import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/build/app_mode_provider.dart';
import '../../../riverpod/build/app_mode_type.dart';
import '../common/common_option_card.dart';
import '../text_widget.dart';

class BuildModeSelection extends ConsumerWidget {
  const BuildModeSelection({super.key});

  IconData _getIconForMode(AppModeType mode) {
    switch (mode) {
      case AppModeType.debug:
        return Icons.bug_report_outlined;
      case AppModeType.release:
        return Icons.rocket_launch_outlined;
      case AppModeType.profile:
        return Icons.dashboard_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(appModeTypeProvider);

    return Container(
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.settings_outlined,
                      size: 22,
                      color: Theme.of(context).colorScheme.primary,
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
                    const TextWidget(
                      'Build Mode',
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      'Choose how your app will be built',
                      size: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppModeType.values.map((mode) {
              return SizedBox(
                width: 300,
                child: CommonOptionCard(
                  title: mode.displayName,
                  description: mode.description,
                  icon: _getIconForMode(mode),
                  isSelected: selectedMode == mode,
                  onTap: () {
                    ref.read(appModeTypeProvider.notifier).state =
                        selectedMode == mode ? null : mode;
                  },
                  maxLines: 2,
                  padding: const EdgeInsets.all(12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
