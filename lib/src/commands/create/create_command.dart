import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'create_app_command.dart';
import 'create_monorepo_command.dart';
import 'create_package_command.dart';

final class CreateCommand extends Command<void> {
  CreateCommand(Logger logger) {
    addSubcommand(CreateMonorepoCommand(logger));
    addSubcommand(CreatePackageCommand(logger));
    addSubcommand(CreateAppCommand(logger));
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create resources from templates.';
}
