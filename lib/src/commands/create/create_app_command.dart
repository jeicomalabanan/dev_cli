import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {}

  final Logger logger;

  @override
  String get name => 'app';

  @override
  String get description => 'Create a Flutter app';
}
