import 'package:injectable/injectable.dart';

import '{{feature_name.snakeCase()}}_local_data_source.dart';

@LazySingleton(as: {{feature_name.pascalCase()}}LocalDataSource)
final class {{feature_name.pascalCase()}}LocalDataSourceImpl implements {{feature_name.pascalCase()}}LocalDataSource {
  const {{feature_name.pascalCase()}}LocalDataSourceImpl();
}
