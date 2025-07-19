part of 'add_order_bloc.dart';

@immutable
abstract class AddOrderEvent {}


class LoadAddOrderProductsData extends AddOrderEvent{
//  final ProductsParams productsParams;
  LoadAddOrderProductsData();
}

/*
class LoadAddOrderData extends AddOrderEvent{
  final UserDataParams userDataParams;
  LoadAddOrderData(this.userDataParams );
}
*/

class AddOrderAddProduct  extends AddOrderEvent{//changed
  final ProductEntity product;
  AddOrderAddProduct(this.product);
}
class IncreaseProductCount extends AddOrderEvent {//new
  final AddOrderProductEntity product;
  IncreaseProductCount(this.product);
}

class DecreaseProductCount extends AddOrderEvent {//new
  final ProductEntity product;
  DecreaseProductCount(this.product);
}
class SetOrder extends AddOrderEvent {//new
  final SetOrderParams setOrderParams;
  SetOrder(this.setOrderParams);
}
class LoadSelectedProductCount extends AddOrderEvent {//new
  final int count;
  LoadSelectedProductCount(this.count);
}
class addCurrentProducts extends AddOrderEvent {
  final ProductEntity product;
  final int count;
  addCurrentProducts(this.product, this.count);
}





