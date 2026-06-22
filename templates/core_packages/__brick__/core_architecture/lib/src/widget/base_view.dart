import 'package:flutter/material.dart';

import '../mixin/lifecycle_mixin.dart';

/// A foundational [StatefulWidget] that serves as the blueprint for all top-level
/// views or screens within the application.
///
/// This class enforces the use of the `base` modifier, ensuring that subclasses
/// must either be `base`, `final`, or `sealed`, preserving the architectural intent
/// of your view layer.
///
/// ### When to use:
/// * Use this as the parent class for any major screen, page, or feature view
///   that requires lifecycle tracking, global error boundaries, or standard analytics tracking.
/// * Avoid using this for small, reusable atomic components (like custom buttons or input fields);
///   use standard [StatelessWidget] or [StatefulWidget] for those.
///
/// ### Example:
/// ```dart
/// final class HomeView extends BaseView {
///   const HomeView({super.key});
///
///   @override
///   State<HomeView> createState() => _HomeViewState();
/// }
/// ```
abstract base class BaseView extends StatefulWidget {
  const BaseView({super.key});
}

/// The companion [State] class for [BaseView] that automatically hooks into
/// app-wide lifecycle states and custom view lifecycle triggers.
///
/// This class mixes in:
/// * [WidgetsBindingObserver]: To listen to native OS-level lifecycle events (e.g., app paused/resumed).
/// * [LifecycleMixin]: To provide structured, granular callbacks for view rendering
///   and initialization states.
///
/// ### When to use:
/// * Always pair this with a subclass of [BaseView].
/// * Use this when your screen needs to safely trigger logic *after* the first frame
///   is drawn, or needs to react to the user minimizing the app.
///
/// ### Example / Use Case:
/// ```dart
/// final class _HomeViewState extends BaseViewState<HomeView> {
///
///   @override
///   void initState() {
///     super.initState();
///     // Standard Flutter initialization
///   }
///
///   // Overriding a method provided by LifecycleMixin
///   @override
///   void onFirstFrameReady() {
///     // Perfect place to fetch data or show a tool-tip without blocking the initial UI render
///     context.read<HomeBloc>().add(FetchInitialData());
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return const Scaffold(
///       body: Center(child: Text('Home Screen')),
///     );
///   }
/// }
/// ```
abstract base class BaseViewState<T extends BaseView> extends State<T>
    with WidgetsBindingObserver, LifecycleMixin<T> {}
