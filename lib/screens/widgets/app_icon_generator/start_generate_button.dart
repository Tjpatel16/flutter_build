import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/app_icon_generator/app_icon_generator_provider.dart';
import '../../../riverpod/image_picker/image_picker_provider.dart';
import '../../../utils/notification_utils.dart';
import '../text_widget.dart';

class StartGenerateButton extends ConsumerWidget {
  const StartGenerateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);
    final appIconState = ref.watch(appIconGeneratorProvider);

    final isEnabled = imageState.image != null;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: AbsorbPointer(
        absorbing: imageState.image == null,
        child: Container(
          width: double.infinity,
          height: 56,
          margin: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    await ref
                        .read(appIconGeneratorProvider.notifier)
                        .generateIcons(imageState.image!);

                    if (!context.mounted) return;
                    Navigator.of(context).pop();

                    if (appIconState.errorMessage != null) {
                      NotificationUtils.showInfo(
                        message: 'Error: ${appIconState.errorMessage}',
                      );
                    } else {
                      NotificationUtils.showInfo(
                        message: 'Icons generated successfully!',
                      );
                    }
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                  'Start Generate',
                  size: 16,
                  weight: FontWeight.w600,
                  color: isEnabled
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
