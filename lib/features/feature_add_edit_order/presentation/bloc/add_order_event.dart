part of 'add_order_bloc.dart';

@immutable
abstract class AddOrderEvent {}


class LoadAddOrderProductsData extends AddOrderEvent{
  final InfParams productsParams;
  LoadAddOrderProductsData(this.productsParams);
}
class LoadOnChangedAddOrderProductsData extends AddOrderEvent{
  final String query;
  LoadOnChangedAddOrderProductsData(this.query);
}
class LoadSearchedProductsData extends AddOrderEvent{
  final List query;
  LoadSearchedProductsData(this.query);
}

class HydrateCartFromOrder extends AddOrderEvent {
  final OrdersEntity order;
  HydrateCartFromOrder(this.order);
}

class ClearCart extends AddOrderEvent {}

class ResetAddOrderScreen extends AddOrderEvent {
  final bool isEdit;
  final OrdersEntity? order;
  ResetAddOrderScreen.create() : isEdit = false, order = null;
  ResetAddOrderScreen.edit(this.order) : isEdit = true;
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
  addCurrentProducts(this.product, this.count,);
}
class addLineItemProducts extends AddOrderEvent {
  final List<LineItem> lineItem;
  addLineItemProducts(this.lineItem);
}





