import '../../../feature_products/domain/entities/product_entity.dart';

class AddOrderSearchState {
  final List<ProductEntity> visibleProducts;
  final bool isSearching;
  final bool isRemoteResult;

  AddOrderSearchState({
    required this.visibleProducts,
    this.isSearching = false,
    this.isRemoteResult = false,
  });

  AddOrderSearchState copyWith({
    List<ProductEntity>? newVisibleProducts,
    bool? isSearching,
    bool? isRemoteResult,
  }) {
    return AddOrderSearchState(
      visibleProducts: newVisibleProducts ?? visibleProducts,
      isSearching: isSearching ?? this.isSearching,
      isRemoteResult: isRemoteResult ?? this.isRemoteResult,
    );
  }
}
