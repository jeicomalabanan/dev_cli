extension EnumByNameX<T extends Enum> on Iterable<T> {
  T? byNameOrNull(String name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }

  T byNameOrDefault(String name, {required T defaultValue}) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return defaultValue;
  }
}
