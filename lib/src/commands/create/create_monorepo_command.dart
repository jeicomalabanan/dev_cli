import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

import '../../utils/process_runner.dart';

final class CreateMonorepoCommand extends Command<void> {
  CreateMonorepoCommand(this.logger) {
    argParser.addOption('name', abbr: 'n', help: 'Name of the monorepo.');
  }

  final Logger logger;

  @override
  String get name => 'monorepo';

  @override
  String get description => 'Create a new monorepo.';

  @override
  FutureOr<void>? run() async {
    final name =
        argResults?['name'] as String? ??
        logger.prompt('What is the name of the monorepo?');

    logger.info('Creating monorepo...');
    logger.detail('Name: $name');

    var currentPath = Directory.current.path;
    print('current path: $currentPath');
    print('Platform.script: ${Platform.script}');
    print('package root: $packageRoot');
    final brickPath = p.join(
      packageRoot,
      'packages',
      'mason_util',
      'bricks',
      'monorepo',
    );
    print('brick path: $brickPath');

    final uri = await Isolate.resolvePackageUri(
      Uri.parse('package:dev_cli/packages/mason_util/mason.yaml'),
    );
    print('uri: $uri');

    // _runMasonTest(name: name, outputDir: currentPath);

    logger.success('Monorepo "$name" created successfully.');
  }

  void _runMason({required String name, required String outputDir}) {
    final result = ProcessRunner.run(
      command: 'mason',
      args: ['make', 'monorepo', '-o', outputDir, '--name', name],
      workingDirectory: '../../../../packages/mason_util',
    );

    if (result.stdout.toString().isNotEmpty) {
      logger.info(result.stdout.toString());
    }

    if (result.stderr.toString().isNotEmpty) {
      logger.err(result.stderr.toString());
    }

    if (result.exitCode != 0) {
      throw Exception('Mason command failed');
    }
  }

  Future<void> _runMasonTest({
    required String name,
    required String outputDir,
  }) async {
    final generator = await MasonGenerator.fromBrick(
      Brick.path('$packageRoot/packages/mason_util/bricks/monorepo'),
    );
    await generator.generate(
      DirectoryGeneratorTarget(Directory('apps/$name')),
      vars: {'name': name},
    );
  }

  String get packageRoot {
    return p.normalize(
      p.join(File(Platform.script.toFilePath()).parent.path, '..'),
    );
  }
}
