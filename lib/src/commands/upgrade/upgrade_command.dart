import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../../utils/process_runner.dart';

final class UpgradeCommand extends Command<void> {
  UpgradeCommand(this.logger);

  final Logger logger;

  @override
  String get name => 'upgrade';

  @override
  String get description => 'Upgrade the Dev CLI to the latest version.';

  @override
  FutureOr<void>? run() async {
    final progress = logger.progress('Checking for updates...');

    final result = await ProcessRunner.run(
      command: 'dart',
      args: [
        'pub',
        'global',
        'activate',
        '--source',
        'git',
        'https://github.com/jeicomalabanan/dev_cli',
        '--git-ref',
        'develop',
      ],
    );

    logger.info('[1/5] Creating Flutter app...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[2/5] Installing dependencies...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[3/5] Generating code...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[4/5] Configuring project...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[5/5] Finalizing...');
    await Future.delayed(const Duration(milliseconds: 1000));

    progress.update('Installing dependencies...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[1/5] Creating Flutter app...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[2/5] Installing dependencies...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[3/5] Generating code...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[4/5] Configuring project...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[5/5] Finalizing...');
    await Future.delayed(const Duration(milliseconds: 1000));

    progress.update('Running build_runner...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[1/5] Creating Flutter app...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[2/5] Installing dependencies...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[3/5] Generating code...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[4/5] Configuring project...');
    await Future.delayed(const Duration(milliseconds: 1000));
    logger.info('[5/5] Finalizing...');
    await Future.delayed(const Duration(milliseconds: 1000));

    if (result.exitCode != 0) {
      progress.fail(result.stderr);
    } else {
      progress.complete('Dev CLI upgraded successfully.');
    }
  }
}
