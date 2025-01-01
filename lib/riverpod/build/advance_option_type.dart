enum AdvanceOptionType {
  html,
  canvaskit;

  String get displayName {
    switch (this) {
      case AdvanceOptionType.html:
        return 'HTML';
      case AdvanceOptionType.canvaskit:
        return 'CanvasKit';
    }
  }

  String get description {
    switch (this) {
      case AdvanceOptionType.html:
        return 'Generate HTML output';
      case AdvanceOptionType.canvaskit:
        return 'Use CanvasKit for rendering';
    }
  }

  String get flag {
    switch (this) {
      case AdvanceOptionType.html:
        return '--web-renderer html';
      case AdvanceOptionType.canvaskit:
        return '--web-renderer canvaskit';
    }
  }
}
