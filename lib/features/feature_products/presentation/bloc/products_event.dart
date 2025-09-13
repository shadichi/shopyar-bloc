part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class LoadData extends ProductsEvent{}

class LoadProductsData extends ProductsEvent{
  final ProductsParams productsParams;
  LoadProductsData(this.productsParams);
}

class RefreshProductsData extends ProductsEvent {
  final Completer<void>? completer;
  RefreshProductsData([this.completer]);
}

