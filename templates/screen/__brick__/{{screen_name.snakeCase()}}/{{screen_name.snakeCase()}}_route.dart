import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '{{screen_name.snakeCase()}}_screen.dart';

final class {{screen_name.pascalCase()}}Route {
  const {{screen_name.pascalCase()}}Route._();

  static const ({String name, String path}) route = (
    name: '{{screen_name.camelCase()}}',
    path: '{{screen_name.paramCase()}}',
  );

  void go(BuildContext context) {
    context.goNamed(route.name);
  }

  static {{screen_name.pascalCase()}}Screen build(BuildContext _, GoRouterState _) {
    return const {{screen_name.pascalCase()}}Screen();
  }
}
