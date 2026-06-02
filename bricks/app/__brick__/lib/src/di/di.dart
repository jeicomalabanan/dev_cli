import 'package:auth/auth_exports.dart' as auth;
import 'package:core/core_exports.dart' as core;
import 'package:framework/framework_exports.dart' as framework;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:post/post_exports.dart' as post;
import 'package:shared/shared_exports.dart' as shared;
import 'package:user/user_exports.dart' as user;

import 'di.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies(Environment environment) async {
  await framework.configureDependencies(getIt, environment);
  await core.configureDependencies(getIt, environment);
  await shared.configureDependencies(getIt, environment);
  // feature packages
  await auth.configureDependencies(getIt, environment);
  await post.configureDependencies(getIt, environment);
  await user.configureDependencies(getIt, environment);
  // app package
  getIt.init(environment: environment.name);
}
