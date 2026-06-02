import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/monorepo_bundle.dart';

final class CreateMonorepoCommand extends Command<void> {
  CreateMonorepoCommand(this.logger) {
    argParser.addOption(_argName, abbr: 'n', help: 'Name of the monorepo.');
  }

  static const _argName = 'name';

  final Logger logger;

  @override
  String get name => 'monorepo';

  @override
  String get description => 'Create a new monorepo.';

  @override
  FutureOr<void>? run() async {
    final name =
        argResults?[_argName] as String? ??
        logger.prompt('What is the name of the monorepo?');

    logger.info('🚀 Creating monorepo...');
    logger.detail('Name: $name');

    final currentDir = Directory.current.path;
    final monorepoDir = path.join(currentDir, name);

    // check if monorepo already exists
    if (Directory(monorepoDir).existsSync()) {
      logger.err('Monorepo "$name" already exists at $monorepoDir');
      exit(1);
    }

    // generate monorepo template from mason bricks
    final generator = await MasonGenerator.fromBundle(monorepoBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(currentDir)),
      vars: {_argName: name},
      fileConflictResolution: FileConflictResolution.overwrite,
    );

    logger.success('✅ Monorepo "$name" created successfully.');
  }
}
