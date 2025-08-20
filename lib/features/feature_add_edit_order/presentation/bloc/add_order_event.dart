part of 'add_order_bloc.dart';

@immutable
abstract class AddOrderEvent {}


class LoadAddOrderProductsData extends AddOrderEvent{
  LoadAddOrderProductsData();
}

class HydrateCartFromOrder extends AddOrderEvent {
  final OrdersEntity order;
  HydrateCartFromOrder(this.order);
}


class AddOrderAddProduct  extends AddOrderEvent{
  final ProductEntity product;
  AddOrderAddProduct(this.product);
}
class IncreaseProductCount extends AddOrderEvent {
  final AddOrderProductEntity product;
  IncreaseProductCount(this.product);
}

class DecreaseProductCount extends AddOrderEvent {
  final ProductEntity product;
  DecreaseProductCount(this.product);
}
class SetOrderEvent extends AddOrderEvent {
  final SetOrderParams setOrderParams;
  SetOrderEvent(this.setOrderParams);
}
class LoadSelectedProductCount extends AddOrderEvent {
  final int count;
  LoadSelectedProductCount(this.count);
}
class addCurrentProducts extends AddOrderEvent {
  final ProductEntity product;
  final int count;
  addCurrentProducts(this.product, this.count);
}





