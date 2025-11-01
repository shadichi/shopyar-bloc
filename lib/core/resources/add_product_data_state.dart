abstract class AddProductDataState {
  const AddProductDataState();
}

class AddProductDataSuccess extends AddProductDataState {
  final dynamic data; // 👈 اینجا رو از List<dynamic>? به dynamic تغییر بده
  const AddProductDataSuccess(this.data);
}

class AddProductDataFailed extends AddProductDataState {
  final String message;
  const AddProductDataFailed(this.message);
}
