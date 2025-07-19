abstract class AddOrderDataState<T> {
  final T? data;
  final String? error;

  const AddOrderDataState(this.data, this.error);
}
class AddOrderDataSuccess<T> extends AddOrderDataState<T> {
  const AddOrderDataSuccess(T? data) : super(data, null);
}
class AddOrderDataFailed<T> extends AddOrderDataState<T>{
  const AddOrderDataFailed(String error) : super(null, error);
}
