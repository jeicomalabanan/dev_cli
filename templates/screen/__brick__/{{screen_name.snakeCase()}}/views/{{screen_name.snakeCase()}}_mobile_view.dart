import 'package:core_architecture/core_architecture.dart';
import 'package:flutter/material.dart';

final class {{screen_name.pascalCase()}}MobileView extends BaseScaffoldView {
  const {{screen_name.pascalCase()}}MobileView({super.key});

  @override
  State<{{screen_name.pascalCase()}}MobileView> createState() => _{{screen_name.pascalCase()}}MobileViewState();
}

final class _{{screen_name.pascalCase()}}MobileViewState
    extends BaseScaffoldViewState<{{screen_name.pascalCase()}}MobileView> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('{{screen_name.titleCase()}}'));
  }

  @override
  Widget buildBody(BuildContext context) {
    throw UnimplementedError('Mobile View is not yet implemented.');
  }
}
