part of 'products_bloc.dart';

class ProductsState extends Equatable{
  final ProductsStatus productsStatus;
  const ProductsState({required this.productsStatus});

  ProductsState copyWith({
    ProductsStatus? newProductsStatus
}){
    return ProductsState(productsStatus: newProductsStatus?? productsStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[ productsStatus];
}
