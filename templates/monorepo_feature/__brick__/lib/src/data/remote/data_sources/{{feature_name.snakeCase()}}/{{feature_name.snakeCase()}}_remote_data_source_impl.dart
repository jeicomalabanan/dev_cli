import 'package:injectable/injectable.dart';

import '{{feature_name.snakeCase()}}_remote_data_source.dart';

@LazySingleton(as: {{feature_name.pascalCase()}}RemoteDataSource)
final class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  const {{feature_name.pascalCase()}}RemoteDataSourceImpl();
}
