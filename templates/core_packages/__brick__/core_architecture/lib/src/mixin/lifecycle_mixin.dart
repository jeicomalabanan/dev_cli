import 'package:core_logging/core_logging.dart';
import 'package:flutter/material.dart';

/// A mixin that simplifies tracking and responding to both Flutter widget lifecycles
/// and application-level lifecycles (e.g., background/foreground transitions, memory warnings).
///
/// ### Why Use This Mixin?
/// In standard Flutter development, managing `WidgetsBindingObserver` introduces boilerplate,
/// requires manual registration/unregistration, and forces you to sort through a broad `switch` statement
/// inside `didChangeAppLifecycleState`.
///
/// `LifecycleMixin` abstracts this implementation away, exposing highly descriptive,
/// single-responsibility hooks (`onAppResumed`, `onWidgetInit`, etc.) directly on your `State` class.
///
/// ### How to Implement
/// Apply it to your [State] class alongside [WidgetsBindingObserver].
///
/// > **Important:** You *must* include `WidgetsBindingObserver` in your `with` clause to allow
/// > this mixin to intercept framework system calls correctly.
///
/// ```dart
/// class MyScreen extends StatefulWidget {
///   const MyScreen({super.key});
///
///   @override
///   State<MyScreen> createState() => _MyScreenState();
/// }
///
/// class _MyScreenState extends State<MyScreen> with WidgetsBindingObserver, LifecycleMixin<MyScreen> {
///   @override
///   void onWidgetInit() {
///     // Kick off initialization or analytics tracking
///   }
///
///   @override
///   void onAppResumed() {
///     // Refresh data when the user brings the app back to the foreground
///   }
/// }
/// ```
mixin LifecycleMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  // Framework Widget Lifecycle Hooks
  // ==========================================

  /// Standard widget initialization hook.
  ///
  /// **When to use:**
  /// * Allocating controllers (`AnimationController`, `ScrollController`, `TextEditingController`).
  /// * Subscribing to long-lived streams or event busses.
  /// * Kicking off early, non-context-dependent API requests or database reads.
  ///
  /// **Example:**
  /// ```dart
  /// late final ScrollController _scrollController;
  ///
  /// @override
  /// void onWidgetInit() {
  ///   _scrollController = ScrollController();
  ///   _analytics.logScreenView(screenName: 'HomeScreen');
  /// }
  /// ```
  @protected
  @mustCallSuper
  void onWidgetInit() {}

  /// Hook for actions depending on the widget's location in the element tree.
  ///
  /// **When to use:**
  /// * Fetching values from an inherited provider or InheritedWidget (e.g., `Theme.of(context)` or `Provider.of<T>(context)`).
  /// * Executing code that runs both on layout initialization *and* whenever inherited dependencies update.
  ///
  /// **Example:**
  /// ```dart
  /// late LocalizationService _localization;
  ///
  /// @override
  /// void onDependenciesChanged() {
  ///   _localization = LocalizationProvider.of(context);
  ///   _fetchLocalizedContent(_localization.currentLocale);
  /// }
  /// ```
  @protected
  @mustCallSuper
  void onDependenciesChanged() {}

  /// Hook for reacting to parent-driven widget configuration changes.
  ///
  /// **When to use:**
  /// * Re-triggering calculations, streams, or UI resets when properties passed down by the parent change.
  /// * Comparing field-by-field differences between `widget` and [oldWidget].
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onWidgetUpdated(covariant MyWidget oldWidget) {
  ///   if (widget.userId != oldWidget.userId) {
  ///     _fetchUserDataForId(widget.userId);
  ///   }
  /// }
  /// ```
  @protected
  @mustCallSuper
  void onWidgetUpdated(covariant T oldWidget) {}

  /// Standard widget cleanup hook.
  ///
  /// **When to use:**
  /// * **Crucial for performance and memory optimization.**
  /// * Canceling stream subscriptions, timers, or long-running async operations.
  /// * Disposing local controllers to prevent memory leaks.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onWidgetDispose() {
  ///   _pollingTimer?.cancel();
  ///   _scrollController.dispose();
  /// }
  /// ```
  @protected
  @mustCallSuper
  void onWidgetDispose() {}

  // ==========================================
  // App System/Lifecycle Hooks
  // ==========================================

  /// Triggered when the app returns to the foreground and becomes visible/interactive.
  ///
  /// **When to use:**
  /// * Polling an API to grab fresh state after the user was away.
  /// * Checking for app updates, active push notifications, or deep-link routing flags.
  /// * Resuming paused video players or background loops.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onAppResumed() {
  ///   _syncInboxMessages();
  ///   _videoPlayerController.play();
  /// }
  /// ```
  @protected
  void onAppResumed() {}

  /// Triggered when the application is completely hidden from the user and running in the background.
  ///
  /// **When to use:**
  /// * Pausing heavy visual processes, loops, timers, or locations tracking to preserve user battery.
  /// * Auto-saving draft data locally to ensure state preservation.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onAppPaused() {
  ///   _draftAutoSaveService.saveProgress(_textController.text);
  ///   _videoPlayerController.pause();
  /// }
  /// ```
  @protected
  void onAppPaused() {}

  /// Triggered during OS transitions where the app is briefly non-interactive.
  ///
  /// **When to use:**
  /// * Occurs during phone call banners, pulling down the iOS Control Center/Android Status bar, or native system dialog prompts.
  /// * Use this to temporarily blur sensitive content on screen (like financial data or password forms) for privacy security.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onAppInactive() {
  ///   setState(() => _isBlurOverlayVisible = true);
  /// }
  /// ```
  @protected
  void onAppInactive() {}

  /// Triggered when the engine is detached from the host operating system and is about to terminate.
  ///
  /// **When to use:**
  /// * Final emergency operations before the process dies.
  /// * *Note:* Do not rely heavily on this for saving massive payloads, as the OS can kill the process abruptly.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onAppDetached() {
  ///   _socketClient.disconnectImmediate();
  /// }
  /// ```
  @protected
  void onAppDetached() {}

  /// Triggered when the application is hidden from view but not yet fully paused.
  ///
  /// **When to use:**
  /// * Common in multi-window environments, split-screen modes, or picture-in-picture transitions.
  /// * Adjust layout rendering scales or suspend auxiliary updates that require full screen visibility.
  @protected
  void onAppHidden() {}

  /// Called when the application's physical metrics change.
  ///
  /// **When to use:**
  /// * Handling UI changes directly tied to orientation changes (Landscape vs Portrait).
  /// * Reacting to native system soft-keyboard expansions or window resizing on desktop platforms.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onMetricsChanged() {
  ///   final edgeInsets = MediaQuery.of(context).viewInsets;
  ///   _adjustCustomScrollPadding(edgeInsets.bottom);
  /// }
  /// ```
  @protected
  void onMetricsChanged() {}

  /// Called when the device's system-wide theme/brightness changes.
  ///
  /// **When to use:**
  /// * Re-rendering explicit third-party graphics, non-declarative styling engines, or map styles (e.g., switching Google Maps from Dark style to Light style) that do not follow the standard `Theme.of(context)` tree automatically.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onPlatformBrightnessChanged() {
  ///   final isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  ///   _mapController.setStyle(isDark ? DarkMapStyle : LightMapStyle);
  /// }
  /// ```
  @protected
  void onPlatformBrightnessChanged() {}

  /// Called when the operating system triggers a low memory warning.
  ///
  /// **When to use:**
  /// * Evicting image caches, unlinking data controllers not currently in the viewport, or flushing local in-memory singletons.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onMemoryPressure() {
  ///   PaintingBinding.instance.imageCache.clear();
  ///   PaintingBinding.instance.imageCache.clearLiveImages();
  /// }
  /// ```
  @protected
  void onMemoryPressure() {}
}
