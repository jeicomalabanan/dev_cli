enum AppPlatform { android, ios, web, windows, linux, macos }

extension AppPlatformX on AppPlatform {
  String get label => switch (this) {
    AppPlatform.android => 'android',
    AppPlatform.ios => 'ios',
    AppPlatform.web => 'web',
    AppPlatform.windows => 'windows',
    AppPlatform.linux => 'linux',
    AppPlatform.macos => 'macos',
  };
}
