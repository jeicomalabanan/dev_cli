import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/app_bundle.dart';
import '../../exceptions/cli_exception.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/app_platform.dart';
import '../../models/enums/app_template.dart';
import '../../utils/file_util.dart';
import '../../utils/process_runner.dart';

final class _Args {
  const _Args({
    required this.template,
    required this.appName,
    required this.org,
    required this.platforms,
  });

  final AppTemplate template;
  final String appName;
  final String org;
  final List<AppPlatform> platforms;
}

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {}

  final Logger logger;

  @override
  String get name => 'app';

  @override
  String get description => 'Create a new Flutter application.';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final progress = logger.progress('Creating app');

    try {
      switch (args.template) {
        case AppTemplate.monorepo:
          await _generateMonorepoApp(
            appDir: path.join(Directory.current.path, 'apps', args.appName),
            args: args,
          );
          break;
        case AppTemplate.basic:
          await _generateBasicApp(
            appDir: path.join(Directory.current.path, args.appName),
            args: args,
          );
          break;
      }
      progress.complete('${args.appName} created successfully.');
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  _Args? _promptArgs() {
    final template = logger.chooseOneEnum(
      message: 'Choose template:',
      values: AppTemplate.values.toList(),
      defaultValue: AppTemplate.monorepo,
    );

    final appName = logger.prompt('Name of the app:', defaultValue: 'user_app');

    final org = logger.prompt('Organization:', defaultValue: 'team.workspace');

    final platforms = logger.chooseAnyEnum(
      message: 'Choose platforms:',
      values: AppPlatform.values.toList(),
      defaultValues: [AppPlatform.android, AppPlatform.ios, AppPlatform.web],
    );

    return _Args(
      template: template,
      appName: appName,
      org: org,
      platforms: platforms,
    );
  }

  Future<void> _generateBasicApp({
    required String appDir,
    required _Args args,
  }) async {
    // check if app already exists
    if (Directory(appDir).existsSync()) {
      throw CliException('"${args.appName}" already exists at $appDir');
    }

    // create app
    final result = await ProcessRunner.run(
      command: 'flutter',
      args: [
        'create',
        '--template=app',
        appDir,
        '--org=${args.org}',
        '--platforms=${args.platforms.map((e) => e.name).join(',')}',
      ],
    );

    if (result.exitCode != 0) {
      throw CliException(result.stderr.toString());
    }
  }

  Future<void> _generateMonorepoApp({
    required String appDir,
    required _Args args,
  }) async {
    await _generateBasicApp(appDir: appDir, args: args);

    final pathsToDelete = [
      '$appDir/lib',
      '$appDir/lib1234',
      '$appDir/test',
      '$appDir/pubspec.yaml',
    ];
    await FileUtil.deletePaths(pathsToDelete);

    // generate app from mason bricks
    final generator = await MasonGenerator.fromBundle(appBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(appDir)),
      vars: {'name': args.appName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}
