import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../riverpod/flutter_info/flutter_info_section_provider.dart';
import 'flutter_info_content.dart';
import 'flutter_info_header.dart';

class FlutterInfoSection extends ConsumerWidget {
  const FlutterInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(flutterInfoSectionProvider);

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
          const FlutterInfoHeader(),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            const FlutterInfoContent(),
          ],
        ],
      ),
    );
  }
}
