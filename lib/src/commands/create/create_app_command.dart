import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../extensions/logger_extensions.dart';
import '../../models/enums/app_platform.dart';
import '../../models/enums/app_template.dart';
import '../../utils/process_runner.dart';

final class _Args {
  const _Args({
    required this.template,
    required this.name,
    required this.org,
    required this.platforms,
  });

  final AppTemplate template;
  final String name;
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

    switch (args.template) {
      case AppTemplate.basic:
        _generateBasicApp(currentDir: Directory.current.path, args: args);
        break;
      case AppTemplate.monorepo:
        _generateMonorepoApp();
        break;
    }
  }

  _Args? _promptArgs() {
    final template = logger.chooseOneEnum(
      message: 'Choose template:',
      values: AppTemplate.values.toList(),
      defaultValue: AppTemplate.monorepo,
    );

    final name = logger.prompt('Name of the app:', defaultValue: 'user_app');

    final org = logger.prompt('Organization:', defaultValue: 'team.workspace');

    final platforms = logger.chooseAnyEnum(
      message: 'Choose platforms:',
      values: AppPlatform.values.toList(),
      defaultValues: [AppPlatform.android, AppPlatform.ios, AppPlatform.web],
    );

    logger.info('🚀 Creating an app...');
    logger.detail('Template     : ${template.name}');
    logger.detail('Name         : $name');
    logger.detail('Organization : $org');
    logger.detail('Platforms    : ${platforms.map((e) => e.name).join(',')}');

    return _Args(
      template: template,
      name: name,
      org: org,
      platforms: platforms,
    );
  }

  void _generateBasicApp({required String currentDir, required _Args args}) {
    final appDir = path.join(currentDir, args.name);

    // check if app already exists
    if (Directory(appDir).existsSync()) {
      logger.err('"${args.name}" already exists at $appDir');
      return;
    }

    final progress = logger.progress('Creating Flutter app...');

    final result = ProcessRunner.run(
      command: 'flutter',
      args: [
        'create',
        '--template=app',
        args.name,
        '--org=${args.org}',
        '--platforms=${args.platforms.map((e) => e.name).join(',')}',
      ],
    );

    if (result.exitCode != 0) {
      progress.fail(result.stderr);
    } else {
      progress.complete(result.stdout);
    }
  }

  void _generateMonorepoApp() {
    // final progress = logger.progress('Creating app...');
    //
    // await createApp();
    //
    // progress.update('Installing dependencies...');
    // await installDependencies();
    //
    // progress.update('Running build_runner...');
    // await runBuildRunner();
    //
    // progress.complete('Done');

    // // create flutter application
    // final result = ProcessRunner.createFlutterApp(
    //   name: args.name,
    //   org: args.org,
    //   platforms: args.platforms.map((e) => e.name).join(','),
    //   targetDirectory: appsDir,
    // );
    // if (result.exitCode != 0) {
    //   logger.err(result.stderr);
    //   return;
    // }

    // // final pathsToDelete = ['$targetDir/test', '$targetDir/pubspec.yaml'];
    // // await FileUtil.deletePaths(pathsToDelete);
    //
    // // generate app from mason bricks
    // final generator = await MasonGenerator.fromBundle(appBundle);
    // await generator.generate(
    //   DirectoryGeneratorTarget(Directory(appDir)),
    //   vars: {_argKeyName: args.name},
    //   fileConflictResolution: FileConflictResolution.overwrite,
    // );
  }
}
