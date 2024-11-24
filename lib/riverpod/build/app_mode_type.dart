enum AppModeType {
  debug,
  release,
  profile;

  String get displayName {
    switch (this) {
      case AppModeType.debug:
        return 'Debug';
      case AppModeType.release:
        return 'Release';
      case AppModeType.profile:
        return 'Profile';
    }
  }

  String get description {
    switch (this) {
      case AppModeType.debug:
        return 'Development mode with assertions and debugging enabled';
      case AppModeType.release:
        return 'Optimized for deployment with minimal size and maximum performance';
      case AppModeType.profile:
        return 'Performance profiling mode with debugging disabled';
    }
  }

  String get flag {
    switch (this) {
      case AppModeType.debug:
        return '--debug';
      case AppModeType.release:
        return '--release';
      case AppModeType.profile:
        return '--profile';
    }
  }
}
