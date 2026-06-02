import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/app_bundle.dart';
import '../../utils/file_util.dart';
import '../../utils/process_runner.dart';

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {
    argParser
      ..addOption(
        _argAppName,
        abbr: 'n',
        help: 'Flutter application name (snake_case).',
      )
      ..addOption(_argOrg, help: 'Organization identifier (e.g. com.example).')
      ..addOption(
        _argPlatforms,
        help: 'Comma-separated list of target platforms (e.g. android,ios).',
      );
  }

  static const _argAppName = 'app_name';
  static const _argOrg = 'org';
  static const _argPlatforms = 'platforms';

  final Logger logger;

  @override
  String get name => 'app';

  @override
  String get description => 'Create a new Flutter application.';

  @override
  FutureOr<void>? run() async {
    final appName =
        argResults?[_argAppName] as String? ??
        logger.prompt('What is the app name?');

    final org =
        argResults?[_argOrg] as String? ??
        logger.prompt('What is the organization identifier?');

    final platforms =
        argResults?[_argPlatforms] as String? ??
        logger.prompt('Which platforms should be supported?');

    logger.info('Creating an app...');
    logger.detail('Name: $appName');
    logger.detail('Org: $org');
    logger.detail('Platforms: $platforms');

    final currentDir = Directory.current.path;
    final appDir = path.join(currentDir, appName);

    final validationError = _validateAppNotExists(
      name: appName,
      outputDir: currentDir,
    );
    if (validationError != null) {
      logger.err(validationError);
      exit(1);
    }

    final result = ProcessRunner.createFlutterApp(
      appName: appName,
      org: org,
      platforms: platforms,
      workingDirectory: currentDir,
    );
    if (result.exitCode != 0) {
      logger.err(result.stderr);
      exit(result.exitCode);
    }

    final pathsToDelete = ['$appDir/test', '$appDir/pubspec.yaml'];
    await FileUtil.deletePaths(pathsToDelete);

    final generator = await MasonGenerator.fromBundle(appBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(appDir)),
      vars: {_argAppName: appName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );

    logger.success('App "$appName" created successfully.');
  }

  String? _validateAppNotExists({
    required String name,
    required String outputDir,
  }) {
    final appPath = path.join(outputDir, name);
    final dir = Directory(appPath);

    if (dir.existsSync()) {
      return 'App "$name" already exists at $appPath';
    }

    return null;
  }
}
