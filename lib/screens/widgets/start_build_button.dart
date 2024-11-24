import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/notification_utils.dart';
import '../../riverpod/home/home_provider.dart';
import '../../riverpod/build/build_output_provider.dart';
import '../../riverpod/build/app_build_provider.dart';
import 'text_widget.dart';

class StartBuildButton extends ConsumerWidget {
  const StartBuildButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final buildType = ref.watch(appBuildTypeProvider);
    final isEnabled = homeState.hasValue &&
        homeState.value!.selectedProjectPath != null &&
        homeState.value!.isValidProject &&
        buildType != null;

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.all(24),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                NotificationUtils.showInfo(
                  message: 'Starting build process...',
                );

                ref.read(buildOutputProvider.notifier).startBuild();
              }
            : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: isEnabled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          backgroundColor: isEnabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          elevation: isEnabled ? 1 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.build_rounded,
              size: 20,
              color: isEnabled
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            TextWidget(
              'Start Build',
              size: 16,
              weight: FontWeight.w600,
              color: isEnabled
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
