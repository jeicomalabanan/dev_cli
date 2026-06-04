import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../../../bundles/feature_bundle.dart';
import '../../exceptions/cli_exception.dart';
import '../../extensions/logger_extensions.dart';
import '../../models/enums/feature_template.dart';
import '../../utils/file_util.dart';
import '../../utils/process_runner.dart';

final class CreateFeatureCommand extends Command<void> {
  CreateFeatureCommand(this.logger);

  final Logger logger;

  @override
  String get name => 'feature';

  @override
  String get description => 'Create a new feature.';

  @override
  FutureOr<void>? run() async {
    final args = _promptArgs();
    if (args == null) return;

    final progress = logger.progress('Creating feature');

    try {
      switch (args.template) {
        case FeatureTemplate.monorepo:
          await _createMonorepoFeature(
            featureDir: path.join(
              Directory.current.path,
              'packages/features',
              args.featureName,
            ),
            args: args,
          );
          break;
        case FeatureTemplate.basic:
          await _createBasicFeature(
            featureDir: path.join(Directory.current.path, args.featureName),
            args: args,
          );
          break;
      }
      progress.complete('Feature "${args.featureName}" created successfully.');
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  Future<void> _createBasicFeature({
    required String featureDir,
    required _Args args,
  }) async {
    // check if feature already exists
    if (Directory(featureDir).existsSync()) {
      throw CliException('"${args.featureName}" already exists at $featureDir');
    }

    // create feature
    final result = await ProcessRunner.run(
      command: 'flutter',
      args: ['create', '--template=package', featureDir],
    );

    if (result.exitCode != 0) {
      throw CliException(result.stderr.toString());
    }
  }

  Future<void> _createMonorepoFeature({
    required String featureDir,
    required _Args args,
  }) async {
    await _createBasicFeature(featureDir: featureDir, args: args);

    final pathsToDelete = [
      '$featureDir/lib',
      '$featureDir/test',
      '$featureDir/analysis_options.yaml',
      '$featureDir/CHANGELOG.md',
      '$featureDir/LICENSE',
      '$featureDir/pubspec.yaml',
      '$featureDir/README.md',
    ];
    await FileUtil.deletePaths(pathsToDelete);

    // generate feature
    final generator = await MasonGenerator.fromBundle(featureBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(featureDir)),
      vars: {'feature_name': args.featureName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }

  _Args? _promptArgs() {
    final template = logger.chooseOneEnum(
      message: 'Choose template:',
      values: FeatureTemplate.values.toList(),
      defaultValue: FeatureTemplate.monorepo,
    );

    final featureName = logger.prompt(
      'Name of the feature:',
      defaultValue: 'auth',
    );

    return _Args(template: template, featureName: featureName);
  }
}

final class _Args {
  const _Args({required this.template, required this.featureName});

  final FeatureTemplate template;
  final String featureName;
}
