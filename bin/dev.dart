import 'package:dev_cli/src/runner/dev_cli_runner.dart';
import 'package:mason/mason.dart';

void main(List<String> arguments) {
  final runner = DevCliRunner(
    executableName: 'dev',
    description: 'Dev CLI',
    logger: Logger(level: Level.verbose),
  );
  runner.run(arguments);
}
