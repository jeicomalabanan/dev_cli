import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../../utils/process_runner.dart';

final class CreateMonorepoCommand extends Command<void> {
  CreateMonorepoCommand(this.logger) {
    argParser.addOption('name', abbr: 'n', help: 'Name of the monorepo.');
  }

  final Logger logger;

  @override
  String get name => 'monorepo';

  @override
  String get description => 'Create a new monorepo.';

  @override
  FutureOr<void>? run() {
    final name =
        argResults?['name'] as String? ??
        logger.prompt('What is the name of the monorepo?');

    logger.info('Creating monorepo...');
    logger.detail('Name: $name');

    _runMason(name: name, outputDir: '');

    logger.success('Monorepo "$name" created successfully.');
  }

  void _runMason({required String name, required String outputDir}) {
    final result = ProcessRunner.run('mason', [
      'make',
      'monorepo',
      '-o',
      outputDir,
      '--name',
      name,
    ]);

    if (result.stdout.toString().isNotEmpty) {
      logger.info(result.stdout.toString());
    }

    if (result.stderr.toString().isNotEmpty) {
      logger.err(result.stderr.toString());
    }

    if (result.exitCode != 0) {
      throw Exception('Mason command failed');
    }
  }
}
