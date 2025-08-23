part of 'products_bloc.dart';

class ProductsState extends Equatable{
  final ProductsStatus productsStatus;
  final bool isLoadingMore;
  const ProductsState({required this.productsStatus, required this.isLoadingMore});

  ProductsState copyWith({
    ProductsStatus? newProductsStatus,
    bool? newIsLoadingMore
}){
    return ProductsState(
      productsStatus: newProductsStatus?? productsStatus, isLoadingMore: newIsLoadingMore?? isLoadingMore);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[ productsStatus, isLoadingMore];
}
