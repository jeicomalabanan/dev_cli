import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import 'create_app_command.dart';
import 'create_package_command.dart';

final class CreateCommand extends Command<void> {
  CreateCommand(Logger logger) {
    addSubcommand(CreatePackageCommand(logger));
    addSubcommand(CreateAppCommand(logger));
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create something (package, feature, etc)';
}
