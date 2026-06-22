/// Defines uniform physical width breakpoints across the application.
abstract final class _ResponsiveBreakpoints {
  /// The maximum width boundary for a device to still be considered a mobile phone.
  static const double mobileMax = 600.0;

  /// The maximum width boundary for a device to be considered a tablet layout.
  /// Anything strictly above this value transitions to a desktop layout.
  static const double tabletMax = 1024.0;
}

/// An enum representing available device viewports based on layout width boundaries.
enum DeviceType {
  /// Small screens typical of mobile phones in portrait or landscape.
  mobile,

  /// Medium screens typical of standard tablets (e.g., iPads, Android tablets).
  tablet,

  /// Large screens typical of laptops, desktops, or widescreen monitors.
  desktop;

  /// Purely determines the [DeviceType] based on the current layout width.
  ///
  /// Matches the width against [_ResponsiveBreakpoints.tabletMax] and
  /// [_ResponsiveBreakpoints.mobileMax] to categorize the active screen environment.
  static DeviceType fromWidth(double width) {
    if (width > _ResponsiveBreakpoints.tabletMax) return DeviceType.desktop;
    if (width > _ResponsiveBreakpoints.mobileMax) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}
