abstract class OrderDataState<T> {
  final List<T>? data; // Now data holds a list of T
  final String? error;

  const OrderDataState(this.data, this.error);
}
class OrderDataSuccess<T> extends OrderDataState<T> {
  const OrderDataSuccess(List<T>? data) : super(data, null);
}
class OrderDataFailed<T> extends OrderDataState<T>{
  const OrderDataFailed(String error) : super(null, error);
}
