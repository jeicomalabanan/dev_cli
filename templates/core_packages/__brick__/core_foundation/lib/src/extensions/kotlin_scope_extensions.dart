/// Scope extensions inspired by Kotlin's standard library.
///
/// These extensions are attached to [Object?], meaning they are available
/// globally across your entire codebase for any data type, widget, or model.
extension KotlinScopeX<T> on T {
  /// Calls the specified function [block] with `this` value as its argument
  /// and returns its result.
  ///
  /// Perfect for mapping objects, transforming data structures, or executing
  /// code blocks safely on nullable variables using the `?.` operator.
  ///
  /// ### Example:
  /// ```dart
  /// // Clean alternative to: if (user != null) { navigate(user); }
  /// fetchUser()?.let((user) => navigateToProfile(user.id, user.name));
  ///
  /// // Inline transformations
  /// final int age = "25".let((it) => int.parse(it));
  /// ```
  R let<R>(R Function(T it) block) {
    return block(this);
  }

  /// Calls the specified function [block] with `this` value as its argument
  /// and returns `this` value.
  ///
  /// Great for side-effects like logging, analytics, or caching data mid-stream
  /// without breaking or altering the return chain.
  ///
  /// ### Example:
  /// ```dart
  /// UserModel parseAndSave(Map<String, dynamic> json) {
  ///   return UserModel.fromJson(json)
  ///       .also((user) => print("Successfully parsed: ${user.id}"))
  ///       .also((user) => localDatabase.saveUser(user)); // Returns original user
  /// }
  /// ```
  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  /// Calls the specified function [block] and returns its result.
  ///
  /// Used to execute an isolated script block or complex initialization sequence
  /// on an object to compute a final output.
  ///
  /// ### Example:
  /// ```dart
  /// final padding = const EdgeInsets.all(16.0).run(() {
  ///   // Run heavy configuration logic here if needed
  ///   return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
  /// });
  /// ```
  R run<R>(R Function() block) {
    return block();
  }

  /// Returns `this` value if it satisfies the given [predicate], or `null`
  /// if it does not.
  ///
  /// Excellent for filtering out invalid inputs, empty strings, or bad API
  /// payloads inline without nesting `if` statements.
  ///
  /// ### Example:
  /// ```dart
  /// // Returns the text only if it has at least 3 characters, otherwise null
  /// final query = searchController.text.takeIf((it) => it.trim().length >= 3);
  /// ```
  T? takeIf(bool Function(T it) predicate) {
    return predicate(this) ? this : null;
  }

  /// Returns `this` value if it DOES NOT satisfy the given [predicate], or `null`
  /// if it does.
  ///
  /// The inverse of [takeIf]. Useful for filtering out specific banned states
  /// or values.
  ///
  /// ### Example:
  /// ```dart
  /// // Returns the error state unless it is a connection timeout error
  /// final localError = apiError.takeUnless((it) => it.type == ErrorType.timeout);
  /// ```
  T? takeUnless(bool Function(T it) predicate) {
    return !predicate(this) ? this : null;
  }
}
