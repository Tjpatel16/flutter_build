import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/flutter_info/flutter_info_provider.dart';
import '../text_widget.dart';
import 'version_row.dart';

class FlutterInfoContent extends ConsumerWidget {
  const FlutterInfoContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flutterInfoState = ref.watch(flutterInfoProvider);

    return flutterInfoState.when(
      data: (info) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VersionRow(
            icon: Icons.flutter_dash,
            label: 'Flutter',
            version: info.flutterVersion,
            onCopy: () {
              Clipboard.setData(
                ClipboardData(text: info.flutterVersion),
              );
            },
          ),
          const SizedBox(height: 12),
          VersionRow(
            icon: Icons.code,
            label: 'Dart',
            version: info.dartVersion,
            onCopy: () {
              Clipboard.setData(
                ClipboardData(text: info.dartVersion),
              );
            },
          ),
        ],
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: TextWidget(
          error.toString(),
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
