import 'package:core_foundation/core_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../mixin/lifecycle_mixin.dart';

/// A foundational, highly structured `StatefulWidget` meant to serve as the
/// base for all top-level screens within the application.
///
/// `BaseScreen` enforces a uniform lifecycle and responsive structure across
/// the application by requiring pairing with a corresponding [BaseScreenState].
///
/// ### When to use:
/// - Use for major features, pages, or tabs (e.g., `HomeScreen`, `ProfileScreen`).
/// - **Do not use** for small, reusable UI components or modular widgets (use
///   standard Flutter widgets like `StatelessWidget` or `StatefulWidget` instead).
///
/// ### Example:
/// ```dart
/// class DashboardScreen extends BaseScreen {
///   const DashboardScreen({super.key});
///
///   @override
///   State<DashboardScreen> createState() => _DashboardScreenState();
/// }
/// ```
abstract base class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
}

/// The state companion to [BaseScreen] that manages layout responsiveness,
/// state management injection, and screen lifecycles.
///
/// By extending [BaseScreenState], you automatically inherit:
/// - **Responsive Layouts**: Specialized builder callbacks for mobile, tablet, and desktop viewports.
/// - **Scoped State**: Native integration for injecting standard `BlocProvider` or `Cubit` instances via [buildBlocProviders].
/// - **Lifecycle Monitoring**: Full system and widget lifecycle tracking via `WidgetsBindingObserver` and [LifecycleMixin].
///
/// ### When to use:
/// - Whenever you are building a full-screen view that requires responsive handling.
/// - When a screen heavily relies on dedicated Blocs/Cubits that should only live as long as the screen itself.
///
/// ### Example:
/// ```dart
/// class _DashboardScreenState extends BaseScreenState<DashboardScreen> {
///   @override
///   List<SingleChildWidget> buildBlocProviders() => [
///     BlocProvider<DashboardBloc>(create: (context) => DashboardBloc()..add(FetchData())),
///   ];
///
///   @override
///   Widget buildMobile(BuildContext context, Orientation orientation) {
///     return Scaffold(
///       body: Center(child: Text("Mobile Dashboard")),
///     );
///   }
///
///   @override
///   Widget buildTablet(BuildContext context, Orientation orientation) {
///     return Scaffold(
///       body: Row(children: [Sidebar(), Expanded(child: Text("Tablet Dashboard"))]),
///     );
///   }
/// }
/// ```
abstract base class BaseScreenState<T extends BaseScreen> extends State<T>
    with WidgetsBindingObserver, LifecycleMixin<T> {
  /// Configures and injects a list of `BlocProvider` or `Cubit` dependencies
  /// scoped exclusively to this screen.
  ///
  /// If the returned list is not empty, the internal layout engine automatically
  /// wraps your screen layout inside a `MultiBlocProvider`. This ensures that
  /// nested responsive layout builders can immediately access the blocs via `BlocProvider.of<T>(context)`.
  ///
  /// Override this method *only* if the screen requires dedicated state management.
  ///
  /// ### Use Case:
  /// - Declaring feature-specific blocs that should be automatically disposed
  ///   when the user navigates away from this screen.
  ///
  /// ### Example:
  /// ```dart
  /// @override
  /// List<SingleChildWidget> buildBlocProviders() => [
  ///   BlocProvider<AnalyticsBloc>(create: (context) => AnalyticsBloc()),
  ///   BlocProvider<UserCubit>(create: (context) => UserCubit()),
  /// ];
  /// ```
  List<SingleChildWidget> buildBlocProviders() => [];

  /// Core rendering loop that orchestrates state injection and responsive fallback chains.
  ///
  /// *Warning:* Do not override this method in implementing classes. To customize UI,
  /// implement [buildMobile], [buildTablet], and [buildDesktop].
  @override
  Widget build(BuildContext context) {
    final blocProviders = buildBlocProviders();

    // The internal responsive engine mapping viewports to design thresholds.
    final Widget content = ResponsiveBuilder(
      mobile: buildMobile,
      tablet: (context, orientation) =>
          buildTablet(context, orientation) ??
          buildMobile(context, orientation),
      desktop: (context, orientation) =>
          buildDesktop(context, orientation) ??
          buildTablet(context, orientation) ??
          buildMobile(context, orientation),
    );

    // Conditionally apply Blocs/Cubits if explicitly defined by the subclass.
    if (blocProviders.isNotEmpty) {
      return MultiBlocProvider(providers: blocProviders, child: content);
    }

    return content;
  }

  /// Builds the user interface optimized for mobile viewport dimensions.
  ///
  /// This method is abstract and **must** be implemented by every subclass.
  /// It also acts as the baseline fallback layout if [buildTablet] or
  /// [buildDesktop] are omitted or return `null`.
  ///
  /// ### Parameters:
  /// - [context]: The build context containing the inherited theme and media queries.
  /// - [orientation]: The physical orientation (`portrait` or `landscape`) of the device.
  Widget buildMobile(BuildContext context, Orientation orientation);

  /// Builds the user interface optimized for tablet viewport dimensions.
  ///
  /// Override this method to build tailored experiences for medium-sized screens.
  /// Returning `null` instructs the renderer to fall back entirely to [buildMobile].
  ///
  /// ### Use Case:
  /// - Splitting a single-column mobile view into a two-column Master-Detail layout.
  ///
  /// ### Parameters:
  /// - [context]: The build context.
  /// - [orientation]: The physical orientation (`portrait` or `landscape`) of the device.
  Widget? buildTablet(BuildContext context, Orientation orientation) => null;

  /// Builds the user interface optimized for desktop and ultra-wide monitor viewports.
  ///
  /// Override this method to build tailored experiences for large screens.
  /// Returning `null` instructs the renderer to cascade down and attempt to
  /// render [buildTablet] first, and if that is missing, [buildMobile].
  ///
  /// ### Use Case:
  /// - Adding fixed persistence side-navigation drawers, data tables, or multi-pane dashboards.
  ///
  /// ### Parameters:
  /// - [context]: The build context.
  /// - [orientation]: The physical orientation (`portrait` or `landscape`) of the device.
  Widget? buildDesktop(BuildContext context, Orientation orientation) => null;
}
