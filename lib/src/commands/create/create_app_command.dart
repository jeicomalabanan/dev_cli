import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/app_bundle.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/app_platforms.dart';
import '../../utils/process_runner.dart';

const _argKeyName = 'name';
const _argKeyOrg = 'org';
const _argKeyPlatforms = 'platforms';

final class _Args {
  const _Args({required this.name, required this.org, required this.platforms});

  final String name;
  final String org;
  final String platforms;
}

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {
    argParser
      ..addOption(_argKeyName, help: 'Name of the Flutter application.')
      ..addOption(
        _argKeyOrg,
        help: 'Organization identifier (e.g. com.example).',
      )
      ..addOption(
        _argKeyPlatforms,
        help: 'Platforms supported by this application (e.g. android,ios,web).',
      );
  }

  final Logger logger;

  @override
  String get name => 'app';

  @override
  String get description => 'Create a new Flutter application.';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final currentDir = Directory.current.path;
    final appsDir = path.join(currentDir, 'apps');
    final appDir = path.join(appsDir, args.name);

    // check if app already exists
    if (Directory(appDir).existsSync()) {
      logger.err('"${args.name}" already exists at $appDir');
      return;
    }

    // create flutter application
    final result = ProcessRunner.createFlutterApp(
      name: args.name,
      org: args.org,
      platforms: args.platforms,
      workingDirectory: appsDir,
    );
    if (result.exitCode != 0) {
      logger.err(result.stderr);
      return;
    }

    // final pathsToDelete = ['$targetDir/test', '$targetDir/pubspec.yaml'];
    // await FileUtil.deletePaths(pathsToDelete);

    // generate app from mason bricks
    final generator = await MasonGenerator.fromBundle(appBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(appDir)),
      vars: {_argKeyName: args.name},
      fileConflictResolution: FileConflictResolution.overwrite,
    );

    logger.success('✅ "${args.name}" created successfully.');
  }

  _Args? _promptArgs() {
    final name =
        argResults?[_argKeyName] as String? ??
        logger.prompt('What is the name of the app?');

    final org =
        argResults?[_argKeyOrg] as String? ??
        logger.prompt(
          'What is your organization identifier?',
          defaultValue: 'team.workspace',
        );

    final platforms =
        argResults?[_argKeyPlatforms] as String? ??
        logger.chooseAnyEnum(
          message: 'What are your supported platforms?',
          values: AppPlatform.values,
          labelBuilder: (value) => value.label,
          defaultValues: [
            AppPlatform.android,
            AppPlatform.ios,
            AppPlatform.web,
          ],
        );

    logger.info('🚀 Creating an app...');
    logger.detail('Name         : $name');
    logger.detail('Organization : $org');
    logger.detail('Platforms    : $platforms');

    return _Args(name: name, org: org, platforms: platforms);
  }
}
