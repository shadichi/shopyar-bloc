part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class LoadData extends ProductsEvent{}

class LoadProductsData extends ProductsEvent{
  final ProductsParams productsParams;
  LoadProductsData(this.productsParams);
}

