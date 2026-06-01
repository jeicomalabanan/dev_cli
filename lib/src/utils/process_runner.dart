import 'dart:io';

final class ProcessRunner {
  ProcessRunner._();

  static ProcessResult run(String command, List<String> args) {
    return Process.runSync(command, args, runInShell: true);
  }
}
