import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: upgrade this
mixin BlocMixin {
  B getBlocOf<B extends BlocBase<Object?>>(BuildContext context) {
    return context.read<B>();
  }

  B watchBlocOf<B extends BlocBase<Object?>>(BuildContext context) {
    return context.watch<B>();
  }

  void sendEventOf<E>(BuildContext context, Bloc<E, Object?> bloc, E event) {
    bloc.add(event);
  }

  BlocListener<B, S> blocListenerOf<B extends StateStreamable<S>, S>({
    B? bloc,
    required BlocWidgetListener<S> listener,
    BlocListenerCondition<S>? listenWhen,
    Widget? child,
  }) {
    return BlocListener<B, S>(
      bloc: bloc,
      listener: listener,
      listenWhen: listenWhen,
      child: child,
    );
  }

  MultiBlocListener multiBlocListenerOf({
    required List<BlocListener<dynamic, dynamic>> listeners,
    required Widget child,
  }) {
    return MultiBlocListener(listeners: listeners, child: child);
  }

  BlocBuilder<B, S> blocBuilderOf<B extends StateStreamable<S>, S>({
    B? bloc,
    required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: builder,
    );
  }

  BlocConsumer<B, S> blocConsumerOf<B extends StateStreamable<S>, S>({
    B? bloc,
    required BlocWidgetListener<S> listener,
    required BlocWidgetBuilder<S> builder,
    BlocListenerCondition<S>? listenWhen,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocConsumer<B, S>(
      bloc: bloc,
      listener: listener,
      builder: builder,
      listenWhen: listenWhen,
      buildWhen: buildWhen,
    );
  }

  BlocSelector<B, S, T> blocSelectorOf<B extends StateStreamable<S>, S, T>({
    B? bloc,
    required BlocWidgetSelector<S, T> selector,
    required BlocWidgetBuilder<T> builder,
  }) {
    return BlocSelector<B, S, T>(
      bloc: bloc,
      selector: selector,
      builder: builder,
    );
  }
}
