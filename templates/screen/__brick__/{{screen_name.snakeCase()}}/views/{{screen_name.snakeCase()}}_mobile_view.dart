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
    return super.buildAppBar(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    throw UnimplementedError();
  }
}
