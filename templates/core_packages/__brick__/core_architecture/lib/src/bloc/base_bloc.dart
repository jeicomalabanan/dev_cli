import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract base class BaseBlocEvent extends Equatable {
  const BaseBlocEvent();
}

@immutable
abstract base class BaseBlocState extends Equatable {
  const BaseBlocState();
}

abstract base class BaseBloc<E extends BaseBlocEvent, S extends BaseBlocState>
    extends Bloc<E, S> {
  BaseBloc(super.initialState);

  @override
  @mustCallSuper
  void onError(Object error, StackTrace stackTrace) {
    debugPrint('🚨 [BaseBloc Error] in $runtimeType');
    debugPrint('Error: $error');
    debugPrintStack(stackTrace: stackTrace);
    super.onError(error, stackTrace);
  }

  @protected
  void safeEmit(Emitter<S> emit, S state) {
    if (isClosed) return;
    emit(state);
  }
}
