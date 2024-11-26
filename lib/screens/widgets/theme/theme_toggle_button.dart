import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/theme_provider.dart';
import '../text_widget.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeColor = ref.watch(themeColorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const _ThemeDialog(),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
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
                            switch (themeMode) {
                              ThemeMode.system => Icons.brightness_auto,
                              ThemeMode.light => Icons.light_mode,
                              ThemeMode.dark => Icons.dark_mode,
                            },
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
                          Row(
                            children: [
                              TextWidget(
                                switch (themeMode) {
                                  ThemeMode.system => 'System Theme',
                                  ThemeMode.light => 'Light Theme',
                                  ThemeMode.dark => 'Dark Theme',
                                },
                                color: colorScheme.onSurface,
                                weight: FontWeight.w600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeColor.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          TextWidget(
                            'Customize app appearance',
                            color: colorScheme.onSurfaceVariant,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeDialog extends ConsumerWidget {
  const _ThemeDialog();

  static const _availableColors = [
    // Material primary colors
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    // Additional accent colors
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.indigoAccent,
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeColor = ref.watch(themeColorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const TextWidget(
        'Theme Settings',
        size: 20,
        weight: FontWeight.w600,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              'Theme Mode',
              size: 16,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                  label: TextWidget('Auto'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: TextWidget('Light'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: TextWidget('Dark'),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (Set<ThemeMode> selected) {
                ref.read(themeProvider.notifier).changeTheme(selected.first);
              },
              showSelectedIcon: true,
            ),
            const SizedBox(height: 16),
            const TextWidget(
              'Theme Color',
              size: 16,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 240,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: [
                  for (final color in _availableColors)
                    InkWell(
                      onTap: () {
                        ref
                            .read(themeColorProvider.notifier)
                            .changeColor(color);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeColor == color
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: themeColor == color
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const TextWidget('Close'),
        ),
      ],
    );
  }
}
