sealed class Result<D, E extends Object> {
  const Result();
  factory Result.success(D data) => Success(data);
  factory Result.failure(E exception) => Failure(exception);
}

final class Success<D, E extends Object> extends Result<D, E> {
  const Success(this.data);
  final D data;
}

final class Failure<D, E extends Object> extends Result<D, E> {
  const Failure(this.exception);
  final E exception;
}

extension ResultExtension<D, E extends Object> on Result<D, E> {
  /// Returns either a transformed success value or a transformed error value.
  ///
  /// This is a functional-style handler for branching logic depending on
  /// whether the result is [Success] or [Failure].
  T either<T>({
    required T Function(D data) success,
    required T Function(E exception) failure,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Failure(exception: final e) => failure(e),
    };
  }

  /// Returns the contained data when the result is a [Success].
  ///
  /// Returns `null` when the result is a [Failure].
  ///
  /// Useful for optional chaining:
  /// ```dart
  /// final value = result.dataOrNull;
  /// ```
  D? get dataOrNull => switch (this) {
    Success(data: final d) => d,
    Failure() => null,
  };

  /// Returns the contained data when the result is a [Success].
  ///
  /// Throws the exception when the result is a [Failure].
  ///
  /// Useful when you want to fail fast:
  /// ```dart
  /// final data = result.dataOrThrow;
  /// ```
  D get dataOrThrow => switch (this) {
    Success(data: final d) => d,
    Failure(exception: final e) => throw Exception(e),
  };

  /// Returns the contained data when the result is a [Success].
  ///
  /// When the result is a [Failure], returns the optional [fallback] value.
  ///
  /// ```dart
  /// final data = result.dataOrDefault(defaultValue);
  /// ```
  D dataOrDefault(D fallback) => switch (this) {
    Success(data: final d) => d,
    Failure() => fallback,
  };
}
