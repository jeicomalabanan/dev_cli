import 'dart:io';

final class ProcessRunner {
  ProcessRunner._();

  static ProcessResult run({
    required String command,
    required List<String> args,
    String? workingDirectory,
  }) {
    return Process.runSync(
      command,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
  }

  static ProcessResult createFlutterApp({
    required String appName,
    required String org,
    required String platforms,
    String? workingDirectory,
  }) {
    return run(
      command: 'flutter',
      args: [
        'create',
        '--template=app',
        appName,
        '--org=$org',
        '--platforms=$platforms',
        '--empty',
      ],
      workingDirectory: workingDirectory,
    );
  }

  static ProcessResult createFlutterPackage({
    required String packageName,
    String? workingDirectory,
  }) {
    return run(
      command: 'flutter',
      args: ['create', '--template=package', packageName],
      workingDirectory: workingDirectory,
    );
  }

  static ProcessResult createDartPackage({
    required String packageName,
    String? workingDirectory,
  }) {
    return run(
      command: 'dart',
      args: ['create', '--template=package', packageName],
      workingDirectory: workingDirectory,
    );
  }
}
