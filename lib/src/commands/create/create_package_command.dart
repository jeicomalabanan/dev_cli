import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

final class CreatePackageCommand extends Command<void> {
  CreatePackageCommand(this.logger) {}

  final Logger logger;

  @override
  String get name => 'package';

  @override
  String get description => 'Create a new package';

  @override
  FutureOr<void>? run() async {
    final progress = logger.progress('Creating app...');
    await Future.delayed(const Duration(milliseconds: 2000));
    progress.complete('App created.');
  }
}
