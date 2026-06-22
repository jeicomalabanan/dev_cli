import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../mixin/lifecycle_mixin.dart';

/// A base [StatefulWidget] that enforces a unified layout structure across application screens.
///
/// `BaseScaffoldView` must be paired with [BaseScaffoldViewState] to manage the underlying
/// [Scaffold] layout, application lifecycles, and predictive back-navigation interception.
///
/// ### When to use:
/// - Use this as the foundational class for standard, full-screen views that require a [Scaffold].
/// - Use when you need built-in lifecycle tracking or specialized system back-button handling.
///
/// ### Example:
/// ```dart
/// class HomeScreen extends BaseScaffoldView {
///   const HomeScreen({super.key});
///
///   @override
///   State<HomeScreen> createState() => _HomeScreenState();
///}
/// ```
abstract base class BaseScaffoldView extends StatefulWidget {
  const BaseScaffoldView({super.key});
}

/// The state companion to [BaseScaffoldView], responsible for rendering the UI skeleton
/// and handling system interactions safely.
///
/// This class standardizes page layouts by enforcing a `SafeArea` around the [buildBody]
/// and integrates with [WidgetsBindingObserver] and [LifecycleMixin] to monitor app lifecycles.
/// It also leverages Flutter's modern [PopScope] to gracefully handle back-navigation.
///
/// ### Intercepting Back Presses:
/// By default, back navigation is handled by the system. If you need to stop the user from
/// accidentally leaving (e.g., during form submission or unsaved changes), override
/// [shouldInterceptBackPressed] to return `true`, and implement your logic inside [onBackPressed].
abstract base class BaseScaffoldViewState<T extends BaseScaffoldView>
    extends State<T>
    with WidgetsBindingObserver, LifecycleMixin<T> {
  @override
  Widget build(BuildContext context) {
    // Determines if the PopScope allows a native/system pop to occur instantly.
    // If we want to intercept the back press, 'canPop' must be false.
    final canPop = !shouldInterceptBackPressed();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SafeArea(child: buildBody(context)),
        floatingActionButton: buildFloatingActionButton(context),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  /// Internal handler invoked when a pop event is triggered by the system or navigator.
  ///
  /// Evaluates whether the pop was already successful via [didPop]. If not, it executes
  /// the sub-class's custom [onBackPressed] logic to determine if navigation should proceed.
  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    // If the system already handled the pop (canPop was true), do nothing.
    if (didPop) return;

    // Trigger custom intercept logic (e.g., showing a confirmation dialog)
    final handled = await onBackPressed();

    // If the screen didn't swallow the event, proceed with navigation manually.
    if (!handled && mounted) {
      // Since canPop was false, this manual pop bypasses the PopScope loop safely.
      context.pop(result);
    }
  }

  /// Determines whether this view should intercept the system back button/gestures.
  ///
  /// Override this and return `true` if you want [onBackPressed] to catch and evaluate navigation.
  /// Return `false` (default) if the system should pop the screen immediately without checks.
  ///
  /// ### Use Cases:
  /// - Return `true` if a user is mid-checkout or filling out a multi-step form.
  /// - Return `true` if a background process shouldn't be interrupted without warning.
  @protected
  bool shouldInterceptBackPressed() => false;

  /// Custom logic executed when a back navigation attempt is intercepted.
  ///
  /// This method is only called if [shouldInterceptBackPressed] returns `true`.
  /// - Return `true` if your code fully handles the event and you want the user to **stay** on the screen.
  /// - Return `false` if you want to allow the screen to **close/pop** anyway.
  ///
  /// ### Example:
  /// ```dart
  /// @override
  /// bool shouldInterceptBackPressed() => _hasUnsavedChanges;
  ///
  /// @override
  /// Future<bool> onBackPressed() async {
  ///   final shouldDiscard = await showDialog<bool>(
  ///     context: context,
  ///     builder: (ctx) => AlertDialog(
  ///       title: const Text('Unsaved Changes'),
  ///       content: const Text('Do you want to discard your changes?'),
  ///       actions: [
  ///         TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep Editing')),
  ///         TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard')),
  ///       ],
  ///     ),
  ///   );
  ///
  ///   // If user clicked Discard (true), return false to let the view pop.
  ///   // If user clicked Keep Editing (false/null), return true to swallow the event.
  ///   return !(shouldDiscard ?? false);
  /// }
  /// ```
  @protected
  Future<bool> onBackPressed() async => false;

  /// Builds the top app bar of the layout.
  ///
  /// Defaults to `null`. Override this if your screen requires a consistent header.
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Builds the primary interactive content body of the view.
  ///
  /// This widget is automatically wrapped inside a [SafeArea] to respect system cutouts/notches.
  /// This method is abstract and **must** be implemented by every subclass.
  @protected
  Widget buildBody(BuildContext context);

  /// Builds the floating action button (FAB) for the view.
  ///
  /// Defaults to `null`. Override this to provide a primary contextual action on the screen.
  @protected
  Widget? buildFloatingActionButton(BuildContext context) => null;

  /// Builds the bottom navigation bar or persistent bottom sheet for the view.
  ///
  /// Defaults to `null`. Override this if the view requires isolated tab bars or custom toolbars.
  @protected
  Widget? buildBottomNavigationBar(BuildContext context) => null;
}
