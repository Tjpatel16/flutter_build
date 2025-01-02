import 'dart:developer' as developer;
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/image_picker/image_picker_provider.dart';
import '../text_widget.dart';

class ImageSelection extends ConsumerWidget {
  const ImageSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageState = ref.watch(imageProvider);

    return GestureDetector(
      onTap: () => ref.read(imageProvider.notifier).pickFile(),
      child: DropTarget(
        onDragEntered: (details) {
          developer.log("entered");
        },
        onDragExited: (details) {
          developer.log("exited");
        },
        onDragDone: (details) {
          final file = details.files.first;
          ref.read(imageProvider.notifier).dragFile(File(file.path));
        },
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.2),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageState.image == null) ...[
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 30,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      'Dreg & Drop or click to select an image',
                      size: 20,
                      maxLines: 1,
                      weight: FontWeight.w300,
                      overflow: TextOverflow.ellipsis,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      'Image must be 1024x1024 pixels in JPG, JPEG, or PNG format',
                      size: 14,
                      maxLines: 1,
                      weight: FontWeight.w100,
                      overflow: TextOverflow.ellipsis,
                      color: colorScheme.onSurface,
                    ),
                  ] else ...[
                    Image.file(
                      imageState.image!,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      'Path: ${imageState.image!.path}',
                      size: 14,
                      color: colorScheme.onSurface,
                    ),
                  ],
                  if (imageState.validationMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidget(
                        imageState.validationMessage!,
                        color: colorScheme.error,
                      ),
                    ),
                ],
              ),
              if (imageState.image != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(Icons.clear, color: colorScheme.error),
                    onPressed: () {
                      ref.read(imageProvider.notifier).clearImage();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
