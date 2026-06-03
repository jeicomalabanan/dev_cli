import 'dart:io';

final class ProcessRunner {
  ProcessRunner._();

  static Future<ProcessResult> run({
    required String command,
    required List<String> args,
    String? workingDirectory,
  }) {
    return Process.run(
      command,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
  }

  static ProcessResult runSync({
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
    required String name,
    required String org,
    required String platforms,
    String? targetDirectory,
  }) {
    return runSync(
      command: 'flutter',
      args: [
        'create',
        '--template=app',
        '$targetDirectory/$name',
        '--org=$org',
        '--platforms=$platforms',
        '--empty',
      ],
    );
  }

  static ProcessResult createFlutterPackage({
    required String packageName,
    String? workingDirectory,
  }) {
    return runSync(
      command: 'flutter',
      args: ['create', '--template=package', packageName],
      workingDirectory: workingDirectory,
    );
  }

  static ProcessResult createDartPackage({
    required String packageName,
    String? workingDirectory,
  }) {
    return runSync(
      command: 'dart',
      args: ['create', '--template=package', packageName],
      workingDirectory: workingDirectory,
    );
  }
}
