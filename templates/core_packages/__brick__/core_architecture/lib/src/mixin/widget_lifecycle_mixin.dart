import 'package:flutter/material.dart';

/// A mixin designed to decouple and clean up standard Flutter stateful widget
/// lifecycle configurations into explicit, single-responsibility hooks.
///
/// ### Why Use This Mixin?
/// It provides clean abstraction boundaries away from Flutter's native state methods,
/// ensuring your overrides use highly descriptive semantic hooks (`onWidgetInit`, `onWidgetDispose`)
/// instead of overloading raw framework methods.
///
/// ### How to Implement
/// Apply it directly onto your widget's [State] class:
///
/// ```dart
/// class MyWidgetState extends State<MyWidget> with WidgetLifecycleMixin<MyWidget> {
///   @override
///   void onWidgetInit() {
///     // Handle initial setups safely
///   }
/// }
/// ```
mixin WidgetLifecycleMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    onWidgetInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onDependenciesChanged();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    onWidgetUpdated(oldWidget);
  }

  @override
  void dispose() {
    onWidgetDispose();
    super.dispose();
  }

  // ==========================================
  // Framework Widget Lifecycle Hooks
  // ==========================================

  /// Standard widget initialization hook.
  ///
  /// **When to use:**
  /// * Allocating local animation, text, or scroll controllers.
  /// * Subscribing to event streams or state listeners.
  /// * Triggering early repository fetches that don't depend on BuildContext.
  ///
  /// **Example:**
  /// ```dart
  /// late final TextEditingController _textController;
  ///
  /// @override
  /// void onWidgetInit() {
  ///   _textController = TextEditingController();
  /// }
  /// ```
  @protected
  @mustCallSuper
  void onWidgetInit() {}

  /// Hook for actions depending on the widget's location in the element tree.
  ///
  /// **When to use:**
  /// * Fetching values or registering listeners on inherited widgets/providers (e.g., `Theme.of(context)`).
  /// * Code that must execute both at startup *and* whenever upstream configurations change.
  @protected
  @mustCallSuper
  void onDependenciesChanged() {}

  /// Hook for reacting to parent-driven widget configuration updates.
  ///
  /// **When to use:**
  /// * Comparing changes between the previous instance [oldWidget] and the new `widget`.
  /// * Restarting animations, resetting flags, or re-fetching network items based on modified parameters.
  @protected
  @mustCallSuper
  void onWidgetUpdated(covariant T oldWidget) {}

  /// Standard widget cleanup hook.
  ///
  /// **When to use:**
  /// * **Crucial for performance.** Close memory collections, cancel continuous background timers, and dispose controllers.
  @protected
  @mustCallSuper
  void onWidgetDispose() {}
}
