import '../services/storage_service.dart';

extension UiModeExtension on String {
  bool get isCompactMode => this == StorageService.compactUiMode;
  bool get isDetailedMode => this == StorageService.detailedUiMode;

  // Helper methods for specific UI components
  double get cardElevation => isCompactMode ? 0.5 : 2.0;
  double get cardBorderRadius => isCompactMode ? 8.0 : 12.0;
  
  // Spacing and padding
  double get contentPadding => isCompactMode ? 8.0 : 16.0;
  double get itemSpacing => isCompactMode ? 4.0 : 8.0;
  
  // Text sizes
  double get titleSize => isCompactMode ? 14.0 : 16.0;
  double get subtitleSize => isCompactMode ? 12.0 : 14.0;
  
  // Icon sizes
  double get iconSize => isCompactMode ? 18.0 : 24.0;
  
  // Layout properties
  bool get showSubtitle => !isCompactMode;
  bool get showIcon => true; // Always show icons, but size differs
  
  // Animation durations
  Duration get animationDuration => isCompactMode 
      ? const Duration(milliseconds: 150) 
      : const Duration(milliseconds: 250);
}
