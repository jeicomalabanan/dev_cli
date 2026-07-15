part of '{{screen_name.snakeCase()}}_bloc.dart';

sealed class {{screen_name.pascalCase()}}Event extends BaseBlocEvent {
  const {{screen_name.pascalCase()}}Event();
}

final class {{screen_name.pascalCase()}}Started extends {{screen_name.pascalCase()}}Event {
  const {{screen_name.pascalCase()}}Started();

  @override
  List<Object> get props => [];
}
