enum AppType {
  android('Android', 'Generate Android icon'),
  ios('iOS', 'Generate iOS icon'),
  ;

  final String title;
  final String description;

  const AppType(this.title, this.description);
}
