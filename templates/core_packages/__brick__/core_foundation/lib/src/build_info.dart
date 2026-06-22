import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Holds immutable build and version information for the application.
///
/// Initialize this once at app startup via [BuildInfo.initialize].
@immutable
final class BuildInfo {
  // Private constructor prevents arbitrary instantiation outside this class.
  const BuildInfo._({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  // Static backing field for the singleton instance
  static BuildInfo? _instance;

  /// Access the initialized [BuildInfo] instance synchronously.
  ///
  /// Throws a [StateError] if called before [initialize].
  static BuildInfo get instance {
    final currentInstance = _instance;
    if (currentInstance == null) {
      throw StateError(
        'BuildInfo is not initialized. Ensure you await BuildInfo.initialize() in your main().',
      );
    }
    return currentInstance;
  }

  /// Initializes the global [BuildInfo] instance from the platform channels.
  ///
  /// Call this in your `main()` before `runApp()`.
  static Future<BuildInfo> initialize() async {
    // Prevent re-initialization overhead if already loaded
    if (_instance != null) return _instance!;

    final package = await PackageInfo.fromPlatform();

    _instance = BuildInfo._(
      appName: package.appName,
      packageName: package.packageName,
      version: package.version,
      buildNumber: package.buildNumber,
    );

    return _instance!;
  }

  /// Handy quality-of-life computed property (e.g., returns "1.0.0 (42)")
  String get fullVersion => '$version ($buildNumber)';

  /// Logs the build information using [debugPrint] to avoid bloating production logs.
  void logInfo() {
    debugPrint('🚀 App Name: $appName');
    debugPrint('📦 App ID: $packageName');
    debugPrint('🧠 Version Name: $version');
    debugPrint('🏷️ Version Code: $buildNumber');
  }
}
