import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

final class App extends StatelessWidget {
  const App({required this._router, super.key});

  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '{{app_name.titleCase()}}',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.lightBlue,
        ),
      ),
      routerConfig: _router,
      builder: FlutterSmartDialog.init(),
    );
  }
}
