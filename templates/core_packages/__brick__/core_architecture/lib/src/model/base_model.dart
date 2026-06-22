import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract base class BaseDomainModel extends Equatable {
  const BaseDomainModel();
}

@immutable
abstract base class BaseRemoteModel extends Equatable {
  const BaseRemoteModel();
}

@immutable
abstract base class BaseEntityModel extends Equatable {
  const BaseEntityModel();
}
