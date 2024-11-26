import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/build/app_build_type.dart';
import '../../../riverpod/build/app_build_provider.dart';
import '../../../riverpod/flutter_info/flutter_info_provider.dart';
import '../text_widget.dart';
import 'build_option_card.dart';

class BuildTypeSelection extends ConsumerWidget {
  const BuildTypeSelection({super.key});

  IconData _getIconForBuildType(AppBuildType type) {
    switch (type) {
      case AppBuildType.androidApk:
        return Icons.android;
      case AppBuildType.androidBundle:
        return Icons.android;
      case AppBuildType.iosIpa:
        return Icons.apple;
      case AppBuildType.webApp:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBuildType = ref.watch(appBuildTypeProvider);
    final flutterInfoState = ref.watch(flutterInfoProvider);
    final isEnabled = flutterInfoState.hasValue;

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
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
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
                      'Build Type',
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      'Choose the type of build you want to create',
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
            children: AppBuildType.values.map((type) {
              final bool isMacOS = Platform.isMacOS;
              final bool canSelectIOS =
                  type == AppBuildType.iosIpa ? isMacOS : true;

              return SizedBox(
                width: 230,
                child: BuildOptionCard(
                  isSelected: selectedBuildType == type,
                  icon: _getIconForBuildType(type),
                  title: type.title,
                  description: type.description,
                  onTap: isEnabled && canSelectIOS && selectedBuildType != type
                      ? () {
                          ref.read(appBuildTypeProvider.notifier).state = type;
                        }
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
