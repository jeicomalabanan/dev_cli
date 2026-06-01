import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../../../bundles/app_bundle.dart';

final class CreateAppCommand extends Command<void> {
  CreateAppCommand(this.logger) {
    argParser.addOption('name', abbr: 'n', help: 'Name of the app.');
  }

  final Logger logger;

  @override
  String get name => 'app';

  @override
  String get description => 'Create an app.';

  @override
  FutureOr<void>? run() async {
    final name =
        argResults?['name'] as String? ??
        logger.prompt('What is the name of the app?');

    logger.info('Creating an app...');
    logger.detail('Name: $name');

    final currentDir = Directory.current.path;
    final appDir = '$currentDir/$name';

    await Process.run('flutter', ['create', name]);

    await _deletePath('$appDir/test');
    await _deletePath('$appDir/lib/main.dart');
    // await _deletePath('$appDir/README.md');

    final generator = await MasonGenerator.fromBundle(appBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory.current),
      vars: {'name': name},
      fileConflictResolution: FileConflictResolution.overwrite,
    );

    logger.success('App "$name" created successfully.');
  }
}

Future<void> _deletePath(String path) async {
  final entity = FileSystemEntity.typeSync(path);

  switch (entity) {
    case FileSystemEntityType.file:
      await File(path).delete();
      break;
    case FileSystemEntityType.directory:
      await Directory(path).delete(recursive: true);
      break;
    default:
      break;
  }
}
