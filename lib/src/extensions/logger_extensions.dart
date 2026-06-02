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
    required List<T> defaultValues,
  }) {
    return chooseAny(
      message,
      choices: values,
      defaultValues: defaultValues,
      display: (choice) => choice.name,
    );
  }
}
