import 'package:core_architecture/core_architecture.dart' as core_architecture;
import 'package:core_foundation/core_foundation.dart' as core_foundation;
import 'package:core_logging/core_logging.dart' as core_logging;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies(Set<String> environment) async {
  final envFilter = NoEnvOrContainsAll(environment);
  // core packages
  await core_logging.configureDependencies(getIt, envFilter);
  await core_foundation.configureDependencies(getIt, envFilter);
  await core_architecture.configureDependencies(getIt, envFilter);
  // feature packages

  // app package
  getIt.init(environmentFilter: envFilter);
}
