import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'create_feature_command.dart';

final class CreateCommand extends Command<void> {
  CreateCommand(this.logger) {
    addSubcommand(CreateFeatureCommand(logger));
  }

  final Logger logger;

  @override
  String get name => 'create';

  @override
  String get description => 'Create resources from bricks.';
}
