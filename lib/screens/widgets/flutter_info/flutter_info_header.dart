import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/flutter_info/flutter_info_provider.dart';
import '../../../riverpod/flutter_info/flutter_info_section_provider.dart';
import '../text_widget.dart';

class FlutterInfoHeader extends ConsumerWidget {
  const FlutterInfoHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(flutterInfoSectionProvider);

    return InkWell(
      onTap: () {
        ref.read(flutterInfoSectionProvider.notifier).state = !isExpanded;
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              Icons.terminal,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const TextWidget(
              'Environment Info',
              size: 18,
              weight: FontWeight.w600,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh_outlined, size: 20),
              onPressed: () {
                ref.read(flutterInfoProvider.notifier).refresh();
              },
              tooltip: 'Refresh versions',
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
