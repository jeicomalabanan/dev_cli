import 'package:flutter/foundation.dart';

import '../model/base_model.dart';

mixin RemoteToEntityMapper<
  Remote extends BaseRemoteModel,
  Entity extends BaseEntityModel
> {
  Entity remoteToEntity(Remote model);

  List<Entity> remoteToEntityList(List<Remote> models) {
    final List<Entity> entities = [];
    for (final model in models) {
      try {
        entities.add(remoteToEntity(model));
      } catch (error, stackTrace) {
        debugPrint(
          '⚠️ [RemoteToEntityMapper] Skipping corrupted item in $runtimeType',
        );
        debugPrint('Error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    return entities;
  }
}

mixin RemoteToDomainMapper<
  Remote extends BaseRemoteModel,
  Domain extends BaseDomainModel
> {
  Domain remoteToDomain(Remote model);

  List<Domain> remoteToDomainList(List<Remote> models) {
    final List<Domain> domains = [];
    for (final model in models) {
      try {
        domains.add(remoteToDomain(model));
      } catch (error, stackTrace) {
        debugPrint(
          '⚠️ [RemoteToDomainMapper] Skipping corrupted item in $runtimeType',
        );
        debugPrint('Error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    return domains;
  }
}

mixin EntityToDomainMapper<
  Entity extends BaseEntityModel,
  Domain extends BaseDomainModel
> {
  Domain entityToDomain(Entity model);

  List<Domain> entityToDomainList(List<Entity> models) {
    final List<Domain> domains = [];
    for (final model in models) {
      try {
        domains.add(entityToDomain(model));
      } catch (error, stackTrace) {
        debugPrint(
          '⚠️ [EntityToDomainMapper] Skipping corrupted item in $runtimeType',
        );
        debugPrint('Error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    return domains;
  }
}
