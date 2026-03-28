sealed class ResourceLoading<T> {
  const ResourceLoading();
}

class Initial<T> extends ResourceLoading<T> {
  const Initial();
}

class Loading<T> extends ResourceLoading<T> {
  const Loading();
}

class Success<T> extends ResourceLoading<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends ResourceLoading<T> {
  final String message;
  const Error(this.message);
}