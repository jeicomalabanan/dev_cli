import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/app_bundle.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/app_platforms.dart';
import '../../utils/process_runner.dart';

const _argName = 'name';
const _argOrg = 'org';
const _argPlatforms = 'platforms';

final class _AppArgs {
  const _AppArgs({
    required this.name,
    required this.org,
    required this.platforms,
  });

  final String name;
  final String org;
  final String platforms;
}

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {
    argParser
      ..addOption(_argName, help: 'Name of the Flutter application.')
      ..addOption(_argOrg, help: 'Organization identifier (e.g. com.example).')
      ..addOption(
        _argPlatforms,
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
    final appArgs = _getArgs() ?? exit(1);

    final currentDir = Directory.current.path;
    final appDir = path.join(currentDir, appArgs.name);

    // check if app already exists
    if (Directory(appDir).existsSync()) {
      logger.err('App "${appArgs.name}" already exists at $appDir');
      exit(1);
    }

    // create flutter application
    final result = ProcessRunner.createFlutterApp(
      name: appArgs.name,
      org: appArgs.org,
      platforms: appArgs.platforms,
      workingDirectory: currentDir,
    );
    if (result.exitCode != 0) {
      logger.err(result.stderr);
      exit(result.exitCode);
    }

    // final pathsToDelete = ['$appDir/test', '$appDir/pubspec.yaml'];
    // await FileUtil.deletePaths(pathsToDelete);

    // generate monorepo from mason bricks
    final generator = await MasonGenerator.fromBundle(appBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(appDir)),
      vars: {_argName: name},
      fileConflictResolution: FileConflictResolution.overwrite,
    );

    logger.success('✅ App "${appArgs.name}" created successfully.');
  }

  _AppArgs? _getArgs() {
    final name =
        argResults?[_argName] as String? ??
        logger.prompt('What is the name of the app?');

    final org =
        argResults?[_argOrg] as String? ??
        logger.prompt('What is your organization identifier?');

    final platforms =
        argResults?[_argPlatforms] as String? ??
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
    logger.detail('Name: $name');
    logger.detail('Org: $org');
    logger.detail('Platforms: $platforms');

    final shouldProceed = logger.confirm('Do you want to proceed?');
    if (shouldProceed) {
      return _AppArgs(name: name, org: org, platforms: platforms);
    } else {
      return null;
    }
  }
}
