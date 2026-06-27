import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../../bundles/monorepo_feature_bundle.dart';
import '../../../exceptions/cli_exception.dart';
import '../../../utils/file_util.dart';
import '../../../utils/process_runner.dart';

final class CreateMonorepoFeatureCommand extends Command<void> {
  CreateMonorepoFeatureCommand(this.logger);

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
      await _createMonorepoFeature(
        featureDir: path.join(
          Directory.current.path,
          'features',
          args.featureName,
        ),
        args: args,
      );

      progress.complete('Feature "${args.featureName}" created successfully.');
    } on CliException catch (e) {
      progress.fail(e.message);
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  _Args? _promptArgs() {
    final featureName = logger.prompt(
      'Name of the feature:',
      defaultValue: 'auth',
    );

    return _Args(
      featureName: ReCase(featureName).snakeCase,
    );
  }

  Future<void> _createMonorepoFeature({
    required String featureDir,
    required _Args args,
  }) async {
    if (Directory(featureDir).existsSync()) {
      throw CliException('"${args.featureName}" already exists at $featureDir');
    }

    await ProcessRunner.createFlutterPackage(packageDir: featureDir);

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

    final generator = await MasonGenerator.fromBundle(monorepoFeatureBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(featureDir)),
      vars: {'feature_name': args.featureName},
      fileConflictResolution: FileConflictResolution.overwrite,
    );
  }
}

final class _Args {
  const _Args({required this.featureName});

  final String featureName;
}
