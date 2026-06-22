import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

extension BlocActionsX<E, S> on Bloc<E, S> {
  /// Adds an event only if a specific condition is met.
  /// Usage: `authBloc.addIf(FetchUserData(), condition: user.isLoggedIn);`
  void addIf(E event, {required bool condition}) {
    if (condition) {
      add(event);
    }
  }

  /// Adds an event only if the current state matches a specific type.
  /// Usage: `chatBloc.addIfState<ChatLoaded>((state) => SendMessage(...));`
  void addIfState<TargetState>(E Function(TargetState state) eventFactory) {
    final currentState = state;
    if (currentState is TargetState) {
      add(eventFactory(currentState));
    }
  }
}

extension BlocTransformerX on Stream<dynamic> {
  /// Debounces events to prevent UI spamming or double-taps.
  /// Essential for search bars or form submissions.
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  /// Drops incoming events if a current event is still processing.
  /// Perfect for infinite scroll pagination or refresh layouts.
  EventTransformer<T> throttle<T>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
  }
}
