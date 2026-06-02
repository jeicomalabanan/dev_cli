import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/monorepo_bundle.dart';

const _argKeyName = 'name';

final class _Args {
  const _Args({required this.name});

  final String name;
}

final class CreateMonorepoCommand extends Command<void> {
  CreateMonorepoCommand(this.logger) {
    argParser.addOption(_argKeyName, help: 'Name of the monorepo.');
  }

  final Logger logger;

  @override
  String get name => 'monorepo';

  @override
  String get description => 'Create a new monorepo.';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final currentDir = Directory.current.path;
    final monorepoDir = path.join(currentDir, args.name);

    // check if monorepo already exists
    if (Directory(monorepoDir).existsSync()) {
      logger.err('"${args.name}" already exists at $monorepoDir');
      return;
    }

    // generate monorepo from mason bricks
    final generator = await MasonGenerator.fromBundle(monorepoBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(monorepoDir)),
      vars: {_argKeyName: args.name},
      fileConflictResolution: FileConflictResolution.overwrite,
    );

    logger.success('✅ "${args.name}" created successfully.');
  }

  _Args? _promptArgs() {
    final name =
        argResults?[_argKeyName] as String? ??
        logger.prompt('What is the name of the monorepo?');

    logger.info('🚀 Creating monorepo...');
    logger.detail('Name: $name');

    return _Args(name: name);
  }
}
