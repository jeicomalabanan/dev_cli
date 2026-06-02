import 'package:mason/mason.dart';

extension LoggerPromptX on Logger {
  String chooseAnyEnum<T extends Enum>({
    required String message,
    required List<T> values,
    required String Function(T value) labelBuilder,
    required List<T> defaultValues,
  }) {
    final selected = chooseAny(
      message,
      choices: values.map(labelBuilder).toList(),
      defaultValues: defaultValues.map(labelBuilder).toList(),
    );

    return selected.join(',');
  }
}
