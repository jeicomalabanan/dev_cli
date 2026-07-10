import 'package:injectable/injectable.dart';

import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';

@LazySingleton(as: {{feature_name.pascalCase()}}Repository)
final class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  const {{feature_name.pascalCase()}}RepositoryImpl();
}
