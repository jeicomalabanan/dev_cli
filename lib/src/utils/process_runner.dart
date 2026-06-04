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
}
