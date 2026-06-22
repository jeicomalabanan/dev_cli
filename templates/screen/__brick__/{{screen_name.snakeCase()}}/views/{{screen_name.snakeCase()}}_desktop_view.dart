import 'package:core_architecture/core_architecture.dart';
import 'package:flutter/material.dart';

final class {{screen_name.pascalCase()}}DesktopView extends BaseScaffoldView {
  const {{screen_name.pascalCase()}}DesktopView({super.key});

  @override
  State<{{screen_name.pascalCase()}}DesktopView> createState() => _{{screen_name.pascalCase()}}DesktopViewState();
}

final class _{{screen_name.pascalCase()}}DesktopViewState
    extends BaseScaffoldViewState<{{screen_name.pascalCase()}}DesktopView> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return super.buildAppBar(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    throw UnimplementedError('Desktop View is not yet implemented.');
  }
}
