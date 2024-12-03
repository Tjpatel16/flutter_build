import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final uiModeProvider = StateNotifierProvider<UiModeNotifier, String>((ref) {
  return UiModeNotifier();
});

class UiModeNotifier extends StateNotifier<String> {
  UiModeNotifier() : super(StorageService.settings?.get(StorageService.uiModeKey) ?? StorageService.compactUiMode);

  void toggleUiMode() {
    final newMode = state == StorageService.compactUiMode
        ? StorageService.detailedUiMode
        : StorageService.compactUiMode;
    
    StorageService.settings?.put(StorageService.uiModeKey, newMode);
    state = newMode;
  }
}
