import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class CreateMonorepoCommand extends Command<void> {
  CreateMonorepoCommand(this.logger) {}

  final Logger logger;

  @override
  String get name => 'monorepo';

  @override
  String get description => 'Create a Flutter app';
}
