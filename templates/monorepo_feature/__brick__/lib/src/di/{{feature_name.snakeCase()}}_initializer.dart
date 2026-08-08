import 'package:injectable/injectable.dart';

@singleton
final class {{feature_name.pascalCase()}}Initializer {
  @PostConstruct(preResolve: true)
  Future<void> init() async {}
}
