import 'package:flutter/material.dart';

import '../../../utils/notification_utils.dart';
import '../text_widget.dart';

class VersionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String version;
  final VoidCallback onCopy;

  const VersionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.version,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                label,
                size: 14,
                weight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 8),
              TextWidget(
                version,
                size: 12,
                weight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              onCopy();
              NotificationUtils.showSuccess(
                message: 'Version copied to clipboard',
              );
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.content_copy_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
