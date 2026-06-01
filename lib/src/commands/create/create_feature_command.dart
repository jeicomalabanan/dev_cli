import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class CreateFeatureCommand extends Command<void> {
  CreateFeatureCommand(this.logger) {}

  final Logger logger;

  @override
  String get name => 'feature';

  @override
  String get description => 'Create a Flutter app';
}
