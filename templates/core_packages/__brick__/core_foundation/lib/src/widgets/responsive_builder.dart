import 'package:flutter/material.dart';

import '../../core_foundation.dart';

/// A specialized signature used by [ResponsiveBuilder] to defer widget evaluation.
///
/// Passes down both the local [BuildContext] and the resolved device [Orientation]
/// allowing developers to adjust layout rules dynamically inside the build context.
typedef ResponsiveOrientationBuilder =
    Widget Function(BuildContext context, Orientation orientation);

/// A highly efficient layout switcher that invokes targeted [ResponsiveOrientationBuilder]
/// closures based on the calculated [DeviceType].
///
/// Layout functions are evaluated lazily; if a device is running on a [DeviceType.mobile] screen,
/// the [desktop] and [tablet] closures are completely ignored, maximizing render performance.
///
/// ### Example Usage:
/// ```dart
/// const ResponsiveBuilder(
///   mobile: (context, orientation) => orientation == Orientation.portrait
///       ? MobilePortraitLayout()
///       : MobileLandscapeLayout(),
///   tablet: (context, orientation) => UniversalTabletLayout(orientation: orientation),
///   desktop: (context, _) => WebDesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive widget builder layout.
  ///
  /// Requires at minimum a [mobile] fallback configuration.
  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  /// Evaluated when the viewport satisfies [DeviceType.mobile].
  /// Acts as the core fallback layout.
  final ResponsiveOrientationBuilder mobile;

  /// Evaluated when the viewport satisfies [DeviceType.tablet].
  /// Falls back to [mobile] if null.
  final ResponsiveOrientationBuilder? tablet;

  /// Evaluated when the viewport satisfies [DeviceType.desktop].
  /// Falls back to [tablet], then [mobile] if null.
  final ResponsiveOrientationBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;
    final currentOrientation = context.orientation;

    // Use a pattern matching switch to find the best layout candidate.
    final chosenBuilder = switch (deviceType) {
      DeviceType.desktop => desktop ?? tablet ?? mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.mobile => mobile,
    };

    return chosenBuilder(context, currentOrientation);
  }
}
