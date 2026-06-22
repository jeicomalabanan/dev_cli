import 'package:core_logging/core_logging.dart';
import 'package:flutter/material.dart';

/// A mixin that abstracts native app-level operating system events (such as backgrounding,
/// hardware metric updates, or platform theme transitions).
///
/// ### Why Use This Mixin?
/// It abstracts away the tedious implementation boilerplates of [WidgetsBindingObserver] and removes
/// the requirement of routing through a bloated `switch` block inside `didChangeAppLifecycleState`.
///
/// ### How to Implement
/// Apply it to your target widget's [State] class.
///
/// > **Important:** You *must* implicitly append `WidgetsBindingObserver` onto your target State's
/// > class definition alongside this mixin to properly intercept engine hooks.
///
/// ```dart
/// class MyState extends State<MyWidget> with WidgetsBindingObserver, AppLifecycleMixin<MyWidget> {
///   @override
///   void onAppResumed() {
///     // Handle application coming back to active view
///   }
/// }
/// ```
mixin AppLifecycleMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResumed();
        break;
      case AppLifecycleState.paused:
        onAppPaused();
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        break;
      case AppLifecycleState.detached:
        onAppDetached();
        break;
      case AppLifecycleState.hidden:
        onAppHidden();
        break;
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    onMetricsChanged();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    onPlatformBrightnessChanged();
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    printWarn('⚠️ Low Memory Warning detected in: ${widget.runtimeType}');
    onMemoryPressure();
  }

  // ==========================================
  // App System/Lifecycle Hooks
  // ==========================================

  /// Triggered when the app returns to the foreground and becomes interactive.
  ///
  /// **When to use:**
  /// * Refreshing feeds, checking auth sessions, or re-verifying real-time syncs after a suspension.
  @protected
  void onAppResumed() {}

  /// Triggered when the app enters the background (e.g. hitting home screen, device sleep).
  ///
  /// **When to use:**
  /// * Autosaving draft states, pausing media streams, or putting high-performance polling mechanisms on standby.
  @protected
  void onAppPaused() {}

  /// Triggered during ephemeral OS overlays (e.g. incoming call notification banners, system alerts).
  ///
  /// **When to use:**
  /// * Pausing gameplay elements or blurring sensitive visual data layout (like banking balances) for temporary security privacy.
  @protected
  void onAppInactive() {}

  /// Triggered when the Flutter view engine is detached from the host native operating system.
  @protected
  void onAppDetached() {}

  /// Triggered when the application is completely hidden from view but not yet fully paused
  /// (such as opening native multi-window or picture-in-picture modes).
  @protected
  void onAppHidden() {}

  /// Triggered on device viewport scale mutations (such as screen rotations or soft-keyboard visibility shifts).
  @protected
  void onMetricsChanged() {}

  /// Triggered on changes to native appearance modes (switching between Light Mode and Dark Mode system-wide).
  @protected
  void onPlatformBrightnessChanged() {}

  /// Triggered when the underlying hardware operating system experiences extreme memory constraint conditions.
  ///
  /// **When to use:**
  /// * Actively dropping heavy cached bitmaps, image sequences, or garbage collecting stale in-memory registries.
  @protected
  void onMemoryPressure() {}
}
