import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import '../home/home_provider.dart';
import '../image_picker/image_picker_provider.dart';

final appIconGeneratorProvider =
    StateNotifierProvider<AppIconGeneratorNotifier, AppIconGeneratorState>(
        (ref) {
  return AppIconGeneratorNotifier(ref);
});

class AppIconGeneratorState {
  final bool isLoading;
  final String? errorMessage;

  AppIconGeneratorState({this.isLoading = false, this.errorMessage});
}

class AppIconGeneratorNotifier extends StateNotifier<AppIconGeneratorState> {
  final Ref ref;

  AppIconGeneratorNotifier(this.ref) : super(AppIconGeneratorState());

  Future<void> generateIcons(File image) async {
    state = AppIconGeneratorState(isLoading: true);

    try {
      final decodedImage = img.decodeImage(image.readAsBytesSync());
      if (decodedImage == null) throw Exception('Failed to decode image');

      final androidSizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
      };

      final iosSizes = {
        'Icon-App-20x20@1x': 20,
        'Icon-App-20x20@2x': 40,
        'Icon-App-20x20@3x': 60,
        'Icon-App-29x29@1x': 29,
        'Icon-App-29x29@2x': 58,
        'Icon-App-29x29@3x': 87,
        'Icon-App-40x40@1x': 40,
        'Icon-App-40x40@2x': 80,
        'Icon-App-40x40@3x': 120,
        'Icon-App-60x60@2x': 120,
        'Icon-App-60x60@3x': 180,
        'Icon-App-76x76@1x': 76,
        'Icon-App-76x76@2x': 152,
        'Icon-App-83.5x83.5@2x': 167,
        'Icon-App-1024x1024@1x': 1024,
      };

      final homeState = ref.read(homeProvider);
      final projectDir = homeState.value?.selectedProjectPath;
      if (projectDir == null) throw Exception('Project directory not found');

      if (ref.read(imageProvider).generateForAndroid) {
        final androidDir = Directory(
            path.join(projectDir, 'android', 'app', 'src', 'main', 'res'));
        if (!androidDir.existsSync()) {
          androidDir.createSync(recursive: true);
        }

        for (var entry in androidSizes.entries) {
          final resizedImage = img.copyResize(decodedImage,
              width: entry.value, height: entry.value);
          final filePath = path.join(
              androidDir.path, 'mipmap-${entry.key}', 'ic_launcher.png');
          File(filePath).createSync(recursive: true);
          File(filePath).writeAsBytesSync(img.encodePng(resizedImage));
        }
      }

      if (ref.read(imageProvider).generateForIOS) {
        final iosDir = Directory(path.join(projectDir, 'ios', 'Runner',
            'Assets.xcassets', 'AppIcon.appiconset'));
        if (!iosDir.existsSync()) {
          iosDir.createSync(recursive: true);
        }

        for (var entry in iosSizes.entries) {
          final resizedImage = img.copyResize(decodedImage,
              width: entry.value, height: entry.value);
          final filePath = path.join(iosDir.path, '${entry.key}.png');
          File(filePath).createSync(recursive: true);
          File(filePath).writeAsBytesSync(img.encodePng(resizedImage));
        }
      }

      ref.read(imageProvider.notifier).clearImage();
      state = AppIconGeneratorState(isLoading: false);
    } catch (e) {
      state =
          AppIconGeneratorState(isLoading: false, errorMessage: e.toString());
    }
  }
}
