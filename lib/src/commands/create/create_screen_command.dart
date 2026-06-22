import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../bundles/screen_bundle.dart';
import '../../exceptions/cli_exception.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/screen_template.dart';

final class CreateScreenCommand extends Command<void> {
  CreateScreenCommand(this.logger);

  final Logger logger;

  @override
  String get name => 'screen';

  @override
  String get description => 'Create a new screen.';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final progress = logger.progress('Creating screen');

    try {
      switch (args.template) {
        case ScreenTemplate.scaffold:
          await _createScaffoldScreen(
            screenDir: path.join(Directory.current.path, args.screenName),
            args: args,
          );
          break;
        case ScreenTemplate.basic:
          throw UnimplementedError('Basic screen not yet implemented');
          break;
      }

      progress.complete('Screen "${args.screenName}" created successfully.');
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  _Args? _promptArgs() {
    final template = logger.chooseOneEnum(
      message: 'Choose template:',
      values: ScreenTemplate.values.toList(),
      defaultValue: ScreenTemplate.scaffold,
    );

    final screenName = logger.prompt(
      'Name of the screen:',
      defaultValue: 'home',
    );

    return _Args(template: template, screenName: ReCase(screenName).snakeCase);
  }

  Future<void> _createScaffoldScreen({
    required String screenDir,
    required _Args args,
  }) async {
    // check if screen already exists
    if (Directory(screenDir).existsSync()) {
      throw CliException('"${args.screenName}" already exists at $screenDir');
    }

    // generate screen
    final generator = await MasonGenerator.fromBundle(screenBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory.current),
      vars: {'screen_name': args.screenName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}

final class _Args {
  const _Args({required this.template, required this.screenName});

  final ScreenTemplate template;
  final String screenName;
}
