import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'create_screen_command.dart';
import 'monorepo/create_monorepo_command.dart';

final class CreateCommand extends Command<void> {
  CreateCommand(this.logger) {
    addSubcommand(CreateMonorepoCommand(logger));
    addSubcommand(CreateScreenCommand(logger));
  }

  final Logger logger;

  @override
  String get name => 'create';

  @override
  String get description => 'Create resources from bricks.';
}
