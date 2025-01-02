import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/image_picker/image_picker_provider.dart';
import '../common/common_option_card.dart';
import '../text_widget.dart';
import 'app_type.dart';

class AppTypeSelection extends ConsumerWidget {
  const AppTypeSelection({super.key});

  IconData _getIconForBuildType(AppType type) {
    switch (type) {
      case AppType.android:
        return Icons.android;
      case AppType.ios:
        return Icons.apple;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);

    return Opacity(
      opacity: imageState.image != null ? 1.0 : 0.5,
      child: AbsorbPointer(
        absorbing: imageState.image == null,
        child: Container(
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
                          Icons.build_outlined,
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
                          'App Platform',
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        TextWidget(
                          'Select the platform you want to generate the app icon for',
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
                children: AppType.values.map((type) {
                  return SizedBox(
                    width: 230,
                    child: CommonOptionCard(
                      title: type.title,
                      description: type.description,
                      icon: _getIconForBuildType(type),
                      isSelected: type == AppType.android
                          ? imageState.generateForAndroid
                          : imageState.generateForIOS,
                      isEnabled: true,
                      onTap: () {
                        if (type == AppType.android) {
                          ref
                              .read(imageProvider.notifier)
                              .toggleGenerateForAndroid();
                        } else {
                          ref.read(imageProvider.notifier).toggleGenerateForIOS();
                        }
                      },
                      maxLines: 1,
                      padding: const EdgeInsets.all(14),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
