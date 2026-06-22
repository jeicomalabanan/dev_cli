import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '{{screen_name.snakeCase()}}_screen.dart';

enum {{screen_name.pascalCase()}}Route {
  initial(name: '{{screen_name.camelCase()}}', path: '{{screen_name.camelCase()}}');

  const {{screen_name.pascalCase()}}Route({required this.name, required this.path});

  final String name;
  final String path;

  void go(BuildContext context) {
    context.goNamed(name);
  }

  static {{screen_name.pascalCase()}}Screen build(BuildContext _, GoRouterState _) {
    return const {{screen_name.pascalCase()}}Screen();
  }
}
