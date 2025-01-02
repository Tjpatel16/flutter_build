import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

final imageProvider =
    StateNotifierProvider<ImageNotifier, ImageState>((ref) => ImageNotifier());

class ImageState {
  final File? image;
  final String? validationMessage;
  final bool generateForAndroid;
  final bool generateForIOS;

  ImageState({
    this.image,
    this.validationMessage,
    this.generateForAndroid = true,
    this.generateForIOS = true,
  });

  ImageState copyWith({
    File? image,
    String? validationMessage,
    bool? generateForAndroid,
    bool? generateForIOS,
  }) {
    return ImageState(
      image: image ?? this.image,
      validationMessage: validationMessage ?? this.validationMessage,
      generateForAndroid: generateForAndroid ?? this.generateForAndroid,
      generateForIOS: generateForIOS ?? this.generateForIOS,
    );
  }
}

class ImageNotifier extends StateNotifier<ImageState> {
  ImageNotifier() : super(ImageState());

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      String? validationMessage = validateImage(file);

      if (validationMessage == null) {
        state = ImageState(image: file, validationMessage: null);
      } else {
        state = ImageState(image: null, validationMessage: validationMessage);
      }
    }
  }

  Future<void> dragFile(File file) async {
    String? validationMessage = validateImage(file);

    if (validationMessage == null) {
      state = ImageState(image: file, validationMessage: null);
    } else {
      state = ImageState(image: null, validationMessage: validationMessage);
    }
  }

  Future<void> clearImage() async {
    state = ImageState(image: null, validationMessage: null);
  }

  String? validateImage(File file) {
    // Check file extension
    final validExtensions = ['jpg', 'jpeg', 'png'];
    final extension = file.path.split('.').last.toLowerCase();
    if (!validExtensions.contains(extension)) {
      return 'Invalid file extension. Only JPG, JPEG, and PNG are allowed.';
    }

    // Check image dimensions
    final image = img.decodeImage(file.readAsBytesSync());
    if (image == null || image.width != 1024 || image.height != 1024) {
      return 'Invalid image dimensions. Image must be 1024x1024 pixels.';
    }
    return null;
  }

  void toggleGenerateForAndroid() {
    state = state.copyWith(generateForAndroid: !state.generateForAndroid);
  }

  void toggleGenerateForIOS() {
    state = state.copyWith(generateForIOS: !state.generateForIOS);
  }
}
