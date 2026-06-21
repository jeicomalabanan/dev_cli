import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'src/app/app.dart';
import 'src/di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies({});
  runApp(App(router: _config));
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey(
  debugLabel: 'root',
);

final GoRouter _config = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: false,
  observers: [],
  routes: [],
  redirect: (context, state) {
    return null;
  },
  errorBuilder: (context, state) {
    return Scaffold(body: Center(child: Text('Route not found: ${state.uri}')));
  },
);
