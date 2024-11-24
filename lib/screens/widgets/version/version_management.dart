import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/home/home_provider.dart';
import '../../../riverpod/version/version_provider.dart';
import '../text_widget.dart';

class VersionManagement extends ConsumerWidget {
  const VersionManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final versionState = ref.watch(versionInfoProvider);

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
              Icon(
                Icons.swap_vert,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              const TextWidget(
                'Version Management',
                size: 18,
                weight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: TextWidget(
              'Manage your app version and build number',
              size: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          homeState.when(
            data: (home) {
              if (home.selectedProjectPath == null) {
                return const Center(
                  child: TextWidget(
                    'Select a project to manage its version',
                    size: 14,
                  ),
                );
              }
              return versionState.when(
                data: (version) => Form(
                  child: Row(
                    children: [
                      Expanded(
                        child: _VersionField(
                          label: 'Version',
                          value: version.version,
                          icon: Icons.tag,
                          onChanged: (value) {
                            ref
                                .read(versionInfoProvider.notifier)
                                .updateVersion(
                                  version: value,
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _VersionField(
                          label: 'Build Number',
                          value: version.buildNumber,
                          icon: Icons.pin_outlined,
                          onChanged: (value) {
                            ref
                                .read(versionInfoProvider.notifier)
                                .updateVersion(
                                  buildNumber: value,
                                );
                          },
                          numbersOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(
                  child: TextWidget(
                    'Error loading version: $error',
                    color: Colors.red,
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Center(
              child: TextWidget(
                'Error loading project: $error',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Function(String) onChanged;
  final bool numbersOnly;

  const _VersionField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onChanged,
    this.numbersOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              TextWidget(
                label,
                size: 14,
                weight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (numbersOnly) {
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Only numbers are allowed';
                }
              } else {
                if (!RegExp(r'^[a-zA-Z0-9.]+$').hasMatch(value)) {
                  return 'Only letters, numbers, and dots are allowed';
                }
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
