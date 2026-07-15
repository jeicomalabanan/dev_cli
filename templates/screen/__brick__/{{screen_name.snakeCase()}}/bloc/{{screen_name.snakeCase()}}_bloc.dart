import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core_architecture/core_architecture.dart';
import 'package:injectable/injectable.dart';

part '{{screen_name.snakeCase()}}_event.dart';
part '{{screen_name.snakeCase()}}_state.dart';

@injectable
final class {{screen_name.pascalCase()}}Bloc extends BaseBloc<{{screen_name.pascalCase()}}Event, {{screen_name.pascalCase()}}State> {
  {{screen_name.pascalCase()}}Bloc() : super(const {{screen_name.pascalCase()}}State()) {
    on<{{screen_name.pascalCase()}}Started>(_on{{screen_name.pascalCase()}}Started);
  }

  FutureOr<void> _on{{screen_name.pascalCase()}}Started(
    {{screen_name.pascalCase()}}Started event,
    Emitter<{{screen_name.pascalCase()}}State> emit,
  ) {}
}
