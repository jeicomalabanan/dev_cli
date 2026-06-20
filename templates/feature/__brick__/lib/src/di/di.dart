import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@injectableInit
Future<void> configureDependencies(
  GetIt getIt,
  EnvironmentFilter envFilter,
) async {
  getIt.init(environmentFilter: envFilter);
}
