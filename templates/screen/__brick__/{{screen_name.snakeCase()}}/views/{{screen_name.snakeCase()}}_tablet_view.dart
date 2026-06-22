import 'package:core_architecture/core_architecture.dart';
import 'package:flutter/material.dart';

final class {{screen_name.pascalCase()}}TabletView extends BaseScaffoldView {
  const {{screen_name.pascalCase()}}TabletView({super.key});

  @override
  State<{{screen_name.pascalCase()}}TabletView> createState() => _{{screen_name.pascalCase()}}TabletViewState();
}

final class _{{screen_name.pascalCase()}}TabletViewState
    extends BaseScaffoldViewState<{{screen_name.pascalCase()}}TabletView> {
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
