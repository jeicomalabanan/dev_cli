import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../exceptions/cli_exception.dart';
import '../../../utils/process_runner.dart';

final class CreateDefaultPackageCommand extends Command<void> {
  CreateDefaultPackageCommand(this.logger);

  final Logger logger;

  @override
  String get name => 'package';

  @override
  String get description => 'Create a new package';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final progress = logger.progress('Creating package');

    try {
      await _createDefaultPackage(
        packageDir: path.join(Directory.current.path, args.packageName),
        args: args,
      );

      progress.complete('Package "${args.packageName}" created successfully.');
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  _Args? _promptArgs() {
    final packageName = logger.prompt(
      'Name of the package:',
      defaultValue: 'shared',
    );

    return _Args(
      packageName: ReCase(packageName).snakeCase,
    );
  }

  Future<void> _createDefaultPackage({
    required String packageDir,
    required _Args args,
  }) async {
    if (Directory(packageDir).existsSync()) {
      throw CliException('"${args.packageName}" already exists at $packageDir');
    }

    await ProcessRunner.createFlutterPackage(packageDir: packageDir);
  }
}

final class _Args {
  const _Args({required this.packageName});

  final String packageName;
}
