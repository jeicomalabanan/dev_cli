import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../../bundles/monorepo_package_bundle.dart';
import '../../../exceptions/cli_exception.dart';
import '../../../utils/file_util.dart';
import '../../../utils/process_runner.dart';

final class CreateMonorepoPackageCommand extends Command<void> {
  CreateMonorepoPackageCommand(this.logger);

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
      await _createMonorepoPackage(
        packageDir: path.join(
          Directory.current.path,
          'packages',
          args.packageName,
        ),
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

  Future<void> _createMonorepoPackage({
    required String packageDir,
    required _Args args,
  }) async {
    if (Directory(packageDir).existsSync()) {
      throw CliException('"${args.packageName}" already exists at $packageDir');
    }

    await ProcessRunner.createFlutterPackage(packageDir: packageDir);

    final pathsToDelete = [
      '$packageDir/lib',
      '$packageDir/test',
      '$packageDir/analysis_options.yaml',
      '$packageDir/CHANGELOG.md',
      '$packageDir/LICENSE',
      '$packageDir/pubspec.yaml',
      '$packageDir/README.md',
    ];
    await FileUtil.deletePaths(pathsToDelete);

    final generator = await MasonGenerator.fromBundle(monorepoPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(packageDir)),
      vars: {'package_name': args.packageName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}

final class _Args {
  const _Args({required this.packageName});

  final String packageName;
}
