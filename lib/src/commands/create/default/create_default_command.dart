import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'create_default_app_command.dart';
import 'create_default_feature_command.dart';
import 'create_default_package_command.dart';

final class CreateDefaultCommand extends Command<void> {
  CreateDefaultCommand(this.logger) {
    addSubcommand(CreateDefaultAppCommand(logger));
    addSubcommand(CreateDefaultFeatureCommand(logger));
    addSubcommand(CreateDefaultPackageCommand(logger));
  }

  final Logger logger;

  @override
  String get name => 'default';

  @override
  String get description => '';
}
