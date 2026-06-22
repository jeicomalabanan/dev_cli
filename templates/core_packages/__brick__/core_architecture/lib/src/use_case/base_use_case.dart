import 'package:flutter/foundation.dart';

import '../result/result.dart';

abstract base class BaseUseCase<
  I extends BaseUseCaseInput,
  O extends BaseUseCaseOutput,
  E extends BaseUseCaseException
> {
  const BaseUseCase();

  @protected
  Future<E?> validateInput(I input) async => null;

  @protected
  Future<O> buildUseCase(I input);

  @protected
  E buildException(Object error, StackTrace stackTrace);

  Future<Result<O, E>> execute(I input) async {
    try {
      // 1. Handle local business validations upfront
      final validationException = await validateInput(input);
      if (validationException != null) {
        return Result.failure(validationException);
      }
      // 2. Wrap infrastructure and asynchronous executions
      final output = await buildUseCase(input);
      return Result.success(output);
    } catch (error, stackTrace) {
      debugPrint('🚨 [BaseUseCase Error] in $runtimeType');
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stackTrace);

      return Result.failure(buildException(error, stackTrace));
    }
  }
}

@immutable
abstract base class BaseUseCaseInput {
  /// {@macro base_use_case_input}
  const BaseUseCaseInput();
}

@immutable
abstract base class BaseUseCaseOutput {
  /// {@macro base_use_case_output}
  const BaseUseCaseOutput();
}

@immutable
abstract base class BaseUseCaseException implements Exception {
  const BaseUseCaseException();
}
