abstract class AddOrderProductsCard<T> {
  final T? data;
  final String? error;

  const AddOrderProductsCard(this.data, this.error);
}
class AddOrderProductsChanged<T> extends AddOrderProductsCard<T> {
  const AddOrderProductsChanged(T? data) : super(data, null);
}
class AddOrderProductsRemoved<T> extends AddOrderProductsCard<T> {
  const AddOrderProductsRemoved(T? data) : super(data, null);
}
class AddOrderProductsCardFailed<T> extends AddOrderProductsCard<T>{
  const AddOrderProductsCardFailed(String error) : super(null, error);
}
