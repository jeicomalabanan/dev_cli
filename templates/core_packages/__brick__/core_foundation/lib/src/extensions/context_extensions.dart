import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/device_type.dart';

// TODO: improve this extension
extension BuildContextX on BuildContext {
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// An ergonomic extension on [BuildContext] providing immediate, high-performance
/// access to layout dimensions, device categorization, and hardware orientation
/// anywhere within the widget tree.
extension ResponsiveContextX on BuildContext {
  /// Fetches the current [Size] of the viewport utilizing [MediaQuery.sizeOf].
  ///
  /// This registers a highly optimized inherited dependency. The dependent widget
  /// will **only** rebuild when the physical dimensions (width or height) of the
  /// window change. It explicitly ignores unrelated [MediaQueryData] mutations
  /// such as software keyboard toggle (`viewInsets`), system text scaling, or
  /// status bar/notch adjustments (`padding`).
  Size get screenSize => MediaQuery.sizeOf(this);

  /// The absolute width of the viewport measured in logical pixels.
  ///
  /// Establishes an inherited subscription to the viewport's width via [screenSize].
  /// Use this property primarily for evaluating layout breakpoints, calculating
  /// horizontal constraints, or scaling UI elements dynamically.
  double get screenWidth => screenSize.width;

  /// The absolute height of the viewport measured in logical pixels.
  ///
  /// Establishes an inherited subscription to the viewport's height via [screenSize].
  /// Use this property primarily for calculating safe scrollable view boundaries,
  /// vertical aspect ratios, or component positioning.
  double get screenHeight => screenSize.height;

  /// Retrieves the current hardware [Orientation] utilizing [MediaQuery.orientationOf].
  ///
  /// Registers a targeted inherited dependency that triggers a widget rebuild
  /// **exclusively** when the device configuration physically transitions between
  /// [Orientation.portrait] and [Orientation.landscape].
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// Whether the viewport is currently wider than it is tall (`Orientation.landscape`).
  ///
  /// Dependent on [orientation]. Returns `true` if the device is held horizontally
  /// or operating in a landscape aspect ratio.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Whether the viewport is currently taller than it is wide (`Orientation.portrait`).
  ///
  /// Dependent on [orientation]. Returns `true` if the device is held vertically
  /// or operating in a portrait aspect ratio.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Categorizes the current layout frame into a specific [DeviceType] based
  /// on the active [screenWidth].
  ///
  /// Evaluated dynamically via [DeviceType.fromWidth].
  DeviceType get deviceType => DeviceType.fromWidth(screenWidth);

  /// Expressive convenience getter verifying if the active environment matches [DeviceType.mobile].
  ///
  /// Rebuilds only when [screenWidth] crosses the defined mobile boundary threshold.
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Expressive convenience getter verifying if the active environment matches [DeviceType.tablet].
  ///
  /// Rebuilds only when [screenWidth] crosses the defined tablet boundary thresholds.
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Expressive convenience getter verifying if the active environment matches [DeviceType.desktop].
  ///
  /// Rebuilds only when [screenWidth] scales past the maximum tablet layout constraint.
  bool get isDesktop => deviceType == DeviceType.desktop;
}

// TODO: improve this extension
extension BlocContextX on BuildContext {
  /// Shortcut to read a Bloc/Cubit instance without subscribing to changes.
  /// Usage: `context.readBloc<AuthBloc>()`
  B readBloc<B extends BlocBase<Object?>>({bool listen = false}) {
    return BlocProvider.of<B>(this, listen: listen);
  }

  /// Shortcut to add an event to a Bloc.
  /// Usage: `context.addEvent<AuthBloc>(LogoutEvent())`
  void addEvent<B extends Bloc<E, Object?>, E>(E event) {
    readBloc<B>().add(event);
  }

  /// Shortcut to watch a Bloc's entire state for UI rebuilds.
  /// Type inference allows you to omit the state type.
  /// Usage: `final state = context.watchState<AuthBloc>();`
  S watchState<B extends BlocBase<S>, S>() {
    return select<B, S>((B bloc) => bloc.state);
  }
}
