import 'package:core_architecture/core_architecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../../../di/di.dart';
import 'bloc/{{screen_name.snakeCase()}}_bloc.dart';
import 'views/{{screen_name.snakeCase()}}_desktop_view.dart';
import 'views/{{screen_name.snakeCase()}}_mobile_view.dart';
import 'views/{{screen_name.snakeCase()}}_tablet_view.dart';

final class {{screen_name.pascalCase()}}Screen extends BaseScreen {
  const {{screen_name.pascalCase()}}Screen({super.key});

  @override
  State<{{screen_name.pascalCase()}}Screen> createState() => _{{screen_name.pascalCase()}}ScreenState();
}

final class _{{screen_name.pascalCase()}}ScreenState extends BaseScreenState<{{screen_name.pascalCase()}}Screen> {
  @override
  List<SingleChildWidget> buildBlocProviders() {
    return [
      BlocProvider<{{screen_name.pascalCase()}}Bloc>(
        create: (context) => getIt<{{screen_name.pascalCase()}}Bloc>(),
      ),
    ];
  }

  @override
  Widget buildMobile(BuildContext context) {
    return const {{screen_name.pascalCase()}}MobileView();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return const {{screen_name.pascalCase()}}TabletView();
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return const {{screen_name.pascalCase()}}DesktopView();
  }
}
