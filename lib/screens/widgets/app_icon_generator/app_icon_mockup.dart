import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/image_picker/image_picker_provider.dart';

class AppIconMockup extends ConsumerWidget {
  const AppIconMockup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);

    final androidIcons = [
      {'name': 'mdpi', 'size': "48"},
      {'name': 'hdpi', 'size': "72"},
      {'name': 'xhdpi', 'size': "96"},
      {'name': 'xxhdpi', 'size': "144"},
      {'name': 'xxxhdpi', 'size': "192"},
    ];

    final iosIcons = [
      {'name': 'Icon-App-20x20@1x', 'size': '20'},
      {'name': 'Icon-App-20x20@2x', 'size': '40'},
      {'name': 'Icon-App-20x20@3x', 'size': '60'},
      {'name': 'Icon-App-29x29@1x', 'size': '29'},
      {'name': 'Icon-App-29x29@2x', 'size': '58'},
      {'name': 'Icon-App-29x29@3x', 'size': '87'},
      {'name': 'Icon-App-40x40@1x', 'size': '40'},
      {'name': 'Icon-App-40x40@2x', 'size': '80'},
      {'name': 'Icon-App-40x40@3x', 'size': '120'},
      {'name': 'Icon-App-60x60@2x', 'size': '120'},
      {'name': 'Icon-App-60x60@3x', 'size': '180'},
      {'name': 'Icon-App-76x76@1x', 'size': '76'},
      {'name': 'Icon-App-76x76@2x', 'size': '152'},
      {'name': 'Icon-App-83.5x83.5@2x', 'size': '167'},
      {'name': 'Icon-App-1024x1024@1x', 'size': '1024'},
    ];

    return imageState.image == null
        ? SizedBox.shrink()
        : Container(
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
              children: [
                Text(
                  'App Icon Mockups',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                _buildMockupSection(
                  context,
                  'Android App Icon',
                  androidIcons
                      .map((icon) => _buildMockupItem(
                          context,
                          imageState.image!,
                          'Android',
                          icon['name'] as String,
                          icon['size'] as String))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                _buildMockupSection(
                  context,
                  'iOS App Icon',
                  iosIcons
                      .map((icon) => _buildMockupItem(
                          context,
                          imageState.image!,
                          'iOS',
                          icon['name'] as String,
                          icon['size'] as String))
                      .toList(),
                ),
              ],
            ),
          );
  }

  Widget _buildMockupSection(
      BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items,
        ),
      ],
    );
  }

  Widget _buildMockupItem(BuildContext context, File image, String platform,
      String name, String size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.parse(size),
          height: double.parse(size),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.file(image, fit: BoxFit.cover),
        ),
        const SizedBox(height: 5),
        Text(
          '$platform\n$name\n${size}x$size',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
