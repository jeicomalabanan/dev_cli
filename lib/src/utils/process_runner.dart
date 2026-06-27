import 'dart:io';

import '../exceptions/cli_exception.dart';

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

  static Future<void> createFlutterApp({
    required String appDir,
    required String appName,
    required String org,
    required String platforms,
  }) async {
    if (Directory(appDir).existsSync()) {
      throw CliException('"$appName" already exists at $appDir');
    }

    final result = await run(
      command: 'flutter',
      args: [
        'create',
        '--template=app',
        appDir,
        '--org=$org',
        '--platforms=$platforms',
      ],
    );

    if (result.exitCode != 0) {
      throw CliException(result.stderr.toString());
    }
  }

  static Future<void> createFlutterPackage({
    required String featureDir,
    required String featureName,
  }) async {
    if (Directory(featureDir).existsSync()) {
      throw CliException('"$featureName" already exists at $featureDir');
    }

    final result = await run(
      command: 'flutter',
      args: ['create', '--template=package', featureDir],
    );

    if (result.exitCode != 0) {
      throw CliException(result.stderr.toString());
    }
  }
}
