import 'package:flutter/material.dart';
import '../text_widget.dart';

class CommonOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final int? maxLines;

  const CommonOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    this.isEnabled = true,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: !isEnabled
          ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
          : isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: !isEnabled
              ? theme.colorScheme.outline.withOpacity(0.1)
              : isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: !isEnabled
                          ? theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.2)
                          : isSelected
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: !isEnabled
                          ? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
                          : isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          title,
                          size: 14,
                          weight: FontWeight.w600,
                          color: !isEnabled
                              ? theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.5)
                              : isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(height: 4),
                        Tooltip(
                          message: description,
                          child: TextWidget(
                            description,
                            size: 12,
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                            color: !isEnabled
                                ? theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.5)
                                : isSelected
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
