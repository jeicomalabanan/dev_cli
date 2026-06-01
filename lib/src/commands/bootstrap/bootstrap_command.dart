import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class BootstrapCommand extends Command<void> {
  BootstrapCommand(Logger logger);

  @override
  String get name => 'bootstrap';

  @override
  String get description => 'Initialize the workspace.';
}
