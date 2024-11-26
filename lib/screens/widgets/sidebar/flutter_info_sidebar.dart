import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../riverpod/flutter_info/flutter_info_provider.dart';
import '../../../riverpod/flutter_info/flutter_info_state.dart';
import '../text_widget.dart';

class FlutterInfoSidebar extends ConsumerWidget {
  const FlutterInfoSidebar({super.key});

  static const _iconSize = 22.0;
  static const _fontSize = 13.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flutterInfoState = ref.watch(flutterInfoProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => ref.read(flutterInfoProvider.notifier).refresh(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            color:
                                colorScheme.primaryContainer.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.flutter_dash_outlined,
                            size: _iconSize,
                            color: colorScheme.primary,
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
                          TextWidget(
                            'Flutter SDK',
                            color: colorScheme.onSurface,
                            weight: FontWeight.w600,
                            size: 16,
                          ),
                          const SizedBox(height: 4),
                          flutterInfoState.when(
                            data: (info) => info.isFlutterAvailable
                                ? _buildVersionInfo(context, info)
                                : _buildErrorMessage(
                                    context, 'Flutter SDK not found'),
                            loading: () => TextWidget(
                              'Loading SDK info...',
                              size: _fontSize,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            error: (_, __) => _buildErrorMessage(
                                context, 'Error loading Flutter SDK info'),
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
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context, FlutterInfoState info) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildVersionText(context, 'Flutter', info.flutterVersion),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        _buildVersionText(context, 'Dart', info.dartVersion),
      ],
    );
  }

  Widget _buildVersionText(BuildContext context, String label, String version) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          '$label:',
          size: _fontSize,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        TextWidget(
          version,
          size: _fontSize,
          color: colorScheme.primary,
          weight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    return TextWidget(
      message,
      size: _fontSize,
      color: Theme.of(context).colorScheme.error,
    );
  }
}
