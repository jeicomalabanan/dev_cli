enum AppPlatform { android, ios, web, windows, linux, macos }

extension AppPlatformX on AppPlatform {
  String get label => switch (this) {
    AppPlatform.android => 'Android',
    AppPlatform.ios => 'Ios',
    AppPlatform.web => 'Web',
    AppPlatform.windows => 'Windows',
    AppPlatform.linux => 'Linux',
    AppPlatform.macos => 'Macos',
  };

  String get description => switch (this) {
    AppPlatform.android => '',
    AppPlatform.ios => '',
    AppPlatform.web => '',
    AppPlatform.windows => '',
    AppPlatform.linux => '',
    AppPlatform.macos => '',
  };
}
