import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../commands/bootstrap/bootstrap_command.dart';
import '../commands/clean/clean_command.dart';
import '../commands/create/create_command.dart';

final class DevCliRunner {
  const DevCliRunner({
    required this.executableName,
    required this.description,
    required this.logger,
  });

  final String executableName;
  final String description;
  final Logger logger;

  void run(List<String> arguments) {
    final runner = CommandRunner<void>(executableName, description)
      ..addCommand(BootstrapCommand(logger))
      ..addCommand(CreateCommand(logger))
      ..addCommand(CleanCommand(logger));

    runner.run(arguments).catchError((error) {
      logger.err(error.toString());
    });
  }
}
