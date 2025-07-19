//error handling
abstract class DataState<T>{//abstract تعریف شده که بشه ازش extends کرد
  final T? data;
  final String? error;

  const DataState(this.data, this.error);
}

class DataSuccess<T> extends DataState<T>{
  const DataSuccess(T? data) : super(data, null);
//data رو میفرسته برای سوپر کلس خودش
}

class DataFailed<T> extends DataState<T>{
  const DataFailed(String error) : super(null, error);
}