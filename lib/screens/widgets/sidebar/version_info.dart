import 'package:flutter/material.dart';
import '../../../services/version_service.dart';
import '../text_widget.dart';

class VersionInfo extends StatefulWidget {
  const VersionInfo({super.key});

  @override
  State<VersionInfo> createState() => _VersionInfoState();
}

class _VersionInfoState extends State<VersionInfo> {
  String? _version;
  bool _hasUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await VersionService.getCurrentVersion();
    setState(() {
      _version = version;
      _hasUpdate = VersionService.hasUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_version == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: colorScheme.primary,
                        size: 22,
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
                        'v$_version',
                        color: colorScheme.onSurface,
                        weight: FontWeight.w600,
                        size: 16,
                      ),
                      if (_hasUpdate) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextWidget(
                              'Update Available',
                              color: colorScheme.onSurfaceVariant,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (_hasUpdate)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: VersionService.openReleasePage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.system_update_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
