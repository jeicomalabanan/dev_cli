import 'package:mason/mason.dart';

extension LoggerPromptX on Logger {
  T chooseOneEnum<T extends Enum>({
    required String message,
    required List<T> values,
    required T defaultValue,
  }) {
    return chooseOne(
      message,
      choices: values,
      defaultValue: defaultValue,
      display: (choice) => choice.name,
    );
  }

  List<T> chooseAnyEnum<T extends Enum>({
    required String message,
    required List<T> values,
    required String Function(T value) nameBuilder,
    required List<T> defaultValues,
  }) {
    final selectedNames = chooseAny(
      message,
      choices: values.map(nameBuilder).toList(),
      defaultValues: defaultValues.map(nameBuilder).toList(),
    );

    return values
        .where((value) => selectedNames.contains(nameBuilder(value)))
        .toList();
  }

  String chooseAnyEnumAsString<T extends Enum>({
    required String message,
    required List<T> values,
    required String Function(T value) nameBuilder,
    required List<T> defaultValues,
  }) {
    final selected = chooseAny(
      message,
      choices: values.map(nameBuilder).toList(),
      defaultValues: defaultValues.map(nameBuilder).toList(),
    );

    return selected.join(',');
  }
}
