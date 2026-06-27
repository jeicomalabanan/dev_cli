import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../../bundles/monorepo_bundle.dart';
import '../../../exceptions/cli_exception.dart';
import 'create_monorepo_app_command.dart';
import 'create_monorepo_feature_command.dart';
import 'create_monorepo_package_command.dart';

final class CreateMonorepoCommand extends Command<void> {
  CreateMonorepoCommand(this.logger) {
    addSubcommand(CreateMonorepoAppCommand(logger));
    addSubcommand(CreateMonorepoFeatureCommand(logger));
    addSubcommand(CreateMonorepoPackageCommand(logger));
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

    final progress = logger.progress('Creating monorepo');

    try {
      await _createMonorepo(
        monorepoDir: path.join(Directory.current.path, args.monorepoName),
        args: args,
      );
      progress.complete(
        'Monorepo "${args.monorepoName}" created successfully.',
      );
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  _Args? _promptArgs() {
    final monorepoName = logger.prompt(
      'Name of the monorepo:',
      defaultValue: 'workspace',
    );

    return _Args(monorepoName: ReCase(monorepoName).snakeCase);
  }

  Future<void> _createMonorepo({
    required String monorepoDir,
    required _Args args,
  }) async {
    // check if monorepo already exists
    if (Directory(monorepoDir).existsSync()) {
      throw CliException(
        '"${args.monorepoName}" already exists at $monorepoDir',
      );
    }

    // generate monorepo
    final generator = await MasonGenerator.fromBundle(monorepoBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory.current),
      vars: {'name': args.monorepoName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}

final class _Args {
  const _Args({required this.monorepoName});

  final String monorepoName;
}
