sealed class Resource<T> {
  const Resource([this.data]);
  final T? data;
}

final class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading([super.data]);
}

final class ResourceSuccess<T> extends Resource<T> {
  const ResourceSuccess([super.data]);
}

final class ResourceError<T> extends Resource<T> {
  const ResourceError(this.exception, [T? data]) : super(data);
  final Exception exception;
}
