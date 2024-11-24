enum AppBuildType {
  androidApk('Android APK', 'apk', 'Build Android APK file'),
  androidBundle('Android Bundle', 'appbundle', 'Build Android App Bundle'),
  iosIpa('iOS IPA', 'ipa', 'Build iOS IPA file'),
  webApp('Web App', 'web', 'Build Web application');

  final String title;
  final String command;
  final String description;

  const AppBuildType(this.title, this.command, this.description);
}
