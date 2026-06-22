import 'dart:async';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// Represents a generic UI or async operation state.
///
/// A [ResultState] can be:
/// - [InitialState] – nothing has started yet
/// - [LoadingState] – an operation is in progress
/// - [SuccessState] – the operation completed successfully with data
/// - [FailureState] – the operation failed with an error/exception
sealed class ResultState<D, E> {
  const ResultState();

  /// Creates an initial state.
  factory ResultState.initial() => const InitialState();

  /// Creates a loading state.
  factory ResultState.loading() => const LoadingState();

  /// Creates a success state containing [data].
  factory ResultState.success(D data) => SuccessState(data);

  /// Creates a failure state containing an [exception].
  factory ResultState.failure(E exception) => FailureState(exception);
}

/// Represents the initial or idle state before any action has occurred.
final class InitialState<D, E> extends ResultState<D, E> {
  const InitialState();
}

/// Represents a loading or in-progress state.
final class LoadingState<D, E> extends ResultState<D, E> {
  const LoadingState();
}

/// Represents a successful operation containing [data].
final class SuccessState<D, E> extends ResultState<D, E> {
  const SuccessState(this.data);

  /// The value produced by a successful operation.
  final D data;
}

/// Represents a failed operation containing an [exception].
final class FailureState<D, E> extends ResultState<D, E> {
  const FailureState(this.exception);

  /// The exception or error describing the failure.
  final E exception;
}

/// Extension helpers for handling [ResultState] without switching manually.
///
/// Provides a unified way to execute callbacks depending on the current state.
/// Also optionally manages a loading dialog using `flutter_smart_dialog`.
extension ResultStateExtension<D, E> on ResultState<D, E> {
  /// Handles the current [ResultState] by invoking the corresponding callback.
  ///
  /// You may pass callbacks for:
  /// - [initial] → when in [InitialState]
  /// - [loading] → when in [LoadingState]
  /// - [success] → when in [SuccessState]
  /// - [failure] → when in [FailureState]
  ///
  /// ### Loading dialog behavior
  ///
  /// If [showDialog] is `true`:
  ///
  /// - On [LoadingState]: a SmartDialog loading dialog is shown, using [message].
  /// - On any other state: the loading dialog is dismissed.
  ///
  /// ---
  ///
  /// Example:
  /// ```dart
  /// state.handle(
  ///   loading: () => print("Loading..."),
  ///   success: (data) => print("Success: $data"),
  ///   failure: (e) => print("Error: $e"),
  ///   showDialog: true,
  /// );
  /// ```
  Future<void> handle({
    void Function()? initial,
    void Function()? loading,
    void Function(D data)? success,
    void Function(E e)? failure,
    String msg = 'Loading...',
    bool showLoadingDialog = false,
  }) async {
    // Handle loading dialog logic
    if (showLoadingDialog) {
      switch (this) {
        case LoadingState():
          await SmartDialog.showLoading(msg: msg);
        default:
          await SmartDialog.dismiss();
      }
    }

    // Handle the state callbacks
    switch (this) {
      case InitialState():
        initial?.call();
      case LoadingState():
        loading?.call();
      case SuccessState(data: final d):
        success?.call(d);
      case FailureState(exception: final e):
        failure?.call(e);
    }
  }
}
