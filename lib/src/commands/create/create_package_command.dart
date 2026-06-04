import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/flutter_package_bundle.dart';
import '../../exceptions/cli_exception.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/package_template.dart';
import '../../utils/file_util.dart';
import '../../utils/process_runner.dart';

final class CreatePackageCommand extends Command<void> {
  CreatePackageCommand(this.logger);

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
      switch (args.template) {
        case PackageTemplate.monorepo:
          await _createMonorepoPackage(
            packageDir: path.join(
              Directory.current.path,
              'packages',
              args.packageName,
            ),
            args: args,
          );
          break;
        case PackageTemplate.basic:
          await _createBasicPackage(
            packageDir: path.join(Directory.current.path, args.packageName),
            args: args,
          );
          break;
      }
      progress.complete('Package "${args.packageName}" created successfully.');
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  _Args? _promptArgs() {
    final template = logger.chooseOneEnum(
      message: 'Choose template:',
      values: PackageTemplate.values.toList(),
      defaultValue: PackageTemplate.monorepo,
    );

    final packageName = logger.prompt(
      'Name of the package:',
      defaultValue: 'shared',
    );

    return _Args(template: template, packageName: packageName);
  }

  Future<void> _createBasicPackage({
    required String packageDir,
    required _Args args,
  }) async {
    // check if package already exists
    if (Directory(packageDir).existsSync()) {
      throw CliException('"${args.packageName}" already exists at $packageDir');
    }

    // create package
    final result = await ProcessRunner.run(
      command: 'flutter',
      args: ['create', '--template=package', packageDir],
    );

    if (result.exitCode != 0) {
      throw CliException(result.stderr.toString());
    }
  }

  Future<void> _createMonorepoPackage({
    required String packageDir,
    required _Args args,
  }) async {
    await _createBasicPackage(packageDir: packageDir, args: args);

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

    // generate package
    final generator = await MasonGenerator.fromBundle(flutterPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(packageDir)),
      vars: {'package_name': args.packageName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}

final class _Args {
  const _Args({required this.template, required this.packageName});

  final PackageTemplate template;
  final String packageName;
}
