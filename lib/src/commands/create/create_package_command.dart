import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class CreatePackageCommand extends Command<void> {
  CreatePackageCommand(this.logger) {}

  final Logger logger;

  @override
  String get name => 'package';

  @override
  String get description => 'Create a new package';
}
