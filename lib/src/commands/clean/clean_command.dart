import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class CleanCommand extends Command<void> {
  CleanCommand(Logger logger);

  @override
  String get name => 'clean';

  @override
  String get description => 'Reset the workspace to a clean state.';
}
