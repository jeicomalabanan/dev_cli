import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../../bundles/monorepo_app_bundle.dart';
import '../../../exceptions/cli_exception.dart';
import '../../../extensions/logger_extensions.dart';
import '../../../models/enums/app_platform.dart';
import '../../../models/enums/app_template.dart';
import '../../../utils/file_util.dart';
import '../../../utils/process_runner.dart';

final class CreateMonorepoAppCommand extends Command<void> {
  CreateMonorepoAppCommand(this.logger);

  final Logger logger;

  @override
  String get name => 'app';

  @override
  String get description => 'Create a new application.';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final progress = logger.progress('Creating app');

    try {
      await _createMonorepoApp(
        appDir: path.join(Directory.current.path, 'apps', args.appName),
        args: args,
      );

      progress.complete('App "${args.appName}" created successfully.');
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
      appName: ReCase(appName).snakeCase,
      org: org,
      platforms: platforms,
    );
  }

  Future<void> _createMonorepoApp({
    required String appDir,
    required _Args args,
  }) async {
    await ProcessRunner.createFlutterApp(
      appDir: appDir,
      appName: args.appName,
      org: args.org,
      platforms: args.platforms.map((e) => e.name).join(','),
    );

    final pathsToDelete = [
      '$appDir/lib',
      '$appDir/test',
      '$appDir/analysis_options.yaml',
      '$appDir/pubspec.lock',
      '$appDir/pubspec.yaml',
      '$appDir/README.md',
    ];
    await FileUtil.deletePaths(pathsToDelete);

    final generator = await MasonGenerator.fromBundle(monorepoAppBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(appDir)),
      vars: {'app_name': args.appName, 'org': args.org},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}

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
