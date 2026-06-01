import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final appName = context.vars['name'] as String;

  final currentDirPath = Directory.current.path;
  final featureDirPath = '$currentDirPath/$appName';

  if (Directory(featureDirPath).existsSync()) {
    context.logger.err('❌ App already exists at $featureDirPath');
    exit(1);
  }

  context.logger.info('');
  context.logger.info('🚀 App Name : $appName');
  context.logger.info('');
  final org = 'team.workspace';
  final platforms = 'android,ios,web';

  final result = await Process.run('flutter', [
    'create',
    '--template=app',
    appName,
    '--org=$org',
    '--platforms=$platforms',
    '--empty',
  ], runInShell: true);

  stdout.write(result.stdout);

  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }
}
