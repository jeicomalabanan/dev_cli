import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/app_bundle.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/app_platform.dart';
import '../../models/enums/app_template.dart';
import '../../utils/enum_utils.dart';
import '../../utils/process_runner.dart';

const _argKeyTemplate = 'template';
const _argKeyName = 'name';
const _argKeyOrg = 'org';
const _argKeyPlatforms = 'platforms';

final class _Args {
  const _Args({
    required this.template,
    required this.name,
    required this.org,
    required this.platforms,
  });

  final String template;
  final String name;
  final String org;
  final String platforms;
}

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {
    argParser
      ..addOption(
        _argKeyTemplate,
        help: 'Specify the template of the application to create.',
        allowed: AppTemplate.values.map((e) => e.name).toList(),
        allowedHelp: {
          for (final template in AppTemplate.values)
            template.name: template.description,
        },
      )
      ..addOption(
        _argKeyName,
        help: 'The app name for this new Flutter application.',
      )
      ..addOption(
        _argKeyOrg,
        help:
            'The organization responsible for the new Flutter application, in reverse domain name notation (e.g. com.example). '
            'This string is used in Java package names and as prefix in the iOS bundle identifier.',
      )
      ..addOption(
        _argKeyPlatforms,
        help: ' The platforms supported by this application.',
        allowed: AppPlatform.values.map((e) => e.name).toList(),
        allowedHelp: {
          for (final platform in AppPlatform.values)
            platform.name: platform.description,
        },
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
    final templateValue = argResults?[_argKeyTemplate] as String?;
    final template =
        AppTemplate.values.byNameOrNull(templateValue ?? '') ??
        logger.chooseOneEnum(
          message: 'Choose template:',
          values: AppTemplate.values,
          defaultValue: AppTemplate.monorepo,
        );

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
        logger.chooseAnyEnumAsString(
          message: 'What are your supported platforms?',
          values: AppPlatform.values,
          nameBuilder: (value) => value.name,
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

    return _Args(
      template: template.name,
      name: name,
      org: org,
      platforms: platforms,
    );
  }
}
