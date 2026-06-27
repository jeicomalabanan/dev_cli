import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import '../../../exceptions/cli_exception.dart';
import '../../../utils/process_runner.dart';

final class CreateDefaultFeatureCommand extends Command<void> {
  CreateDefaultFeatureCommand(this.logger);

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
      await _createDefaultFeature(
        featureDir: path.join(Directory.current.path, args.featureName),
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

  Future<void> _createDefaultFeature({
    required String featureDir,
    required _Args args,
  }) async {
    if (Directory(featureDir).existsSync()) {
      throw CliException('"${args.featureName}" already exists at $featureDir');
    }

    await ProcessRunner.createFlutterPackage(packageDir: featureDir);
  }
}

final class _Args {
  const _Args({required this.featureName});

  final String featureName;
}
