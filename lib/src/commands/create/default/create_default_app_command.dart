import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../exceptions/cli_exception.dart';
import '../../../extensions/logger_extensions.dart';
import '../../../models/enums/app_platform.dart';
import '../../../utils/process_runner.dart';

final class CreateDefaultAppCommand extends Command<void> {
  CreateDefaultAppCommand(this.logger);

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
      await _createDefaultApp(
        appDir: path.join(Directory.current.path, args.appName),
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
    final appName = logger.prompt('Name of the app:', defaultValue: 'user_app');

    final org = logger.prompt('Organization:', defaultValue: 'team.workspace');

    final platforms = logger.chooseAnyEnum(
      message: 'Choose platforms:',
      values: AppPlatform.values.toList(),
      defaultValues: [AppPlatform.android, AppPlatform.ios, AppPlatform.web],
    );

    return _Args(
      appName: ReCase(appName).snakeCase,
      org: org,
      platforms: platforms,
    );
  }

  Future<void> _createDefaultApp({
    required String appDir,
    required _Args args,
  }) async {
    if (Directory(appDir).existsSync()) {
      throw CliException('"${args.appName}" already exists at $appDir');
    }

    await ProcessRunner.createFlutterApp(
      appDir: appDir,
      appName: args.appName,
      org: args.org,
      platforms: args.platforms.map((e) => e.name).join(','),
    );
  }
}

final class _Args {
  const _Args({
    required this.appName,
    required this.org,
    required this.platforms,
  });

  final String appName;
  final String org;
  final List<AppPlatform> platforms;
}
