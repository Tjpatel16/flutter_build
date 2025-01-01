import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/build/advance_option_provider.dart';
import '../../../riverpod/build/advance_option_type.dart';
import '../common/common_option_card.dart';
import '../text_widget.dart';

class AdvanceOptionSelection extends ConsumerWidget {
  const AdvanceOptionSelection({super.key});

  IconData _getIconForMode(AdvanceOptionType mode) {
    switch (mode) {
      case AdvanceOptionType.html:
        return Icons.html_outlined;
      case AdvanceOptionType.canvaskit:
        return Icons.web_asset_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webRender = ref.watch(webRenderProvider);

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
                      'Web Render',
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      'Choose web render mode',
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
            children: AdvanceOptionType.values.map((mode) {
              return SizedBox(
                width: 300,
                child: CommonOptionCard(
                  title: mode.displayName,
                  description: mode.description,
                  icon: _getIconForMode(mode),
                  isSelected: webRender == mode,
                  onTap: () {
                    ref.read(webRenderProvider.notifier).state =
                        webRender == mode ? null : mode;
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
