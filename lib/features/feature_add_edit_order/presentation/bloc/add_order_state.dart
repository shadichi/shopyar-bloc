part of 'add_order_bloc.dart';

class AddOrderState extends Equatable {
  final AddOrderStatus addOrderStatus;
  final AddOrderCardProductStatus addOrderCardProductStatus;
  final AddOrderSetOrderStatus addOrderSetOrderStatus;
  final Map<int, int> count;
  final Map<int, bool> isFirstTime;
  final bool isLoadingMore;
  final bool isSearching;
  final bool isRemoteResult;
  final List<ProductEntity> apiSearchedProducts; // ✅ اضافه شد


  final List<ProductEntity> visibleProducts;

  const AddOrderState({
    required this.addOrderStatus,
    required this.addOrderCardProductStatus,
    required this.addOrderSetOrderStatus,
    required this.count,
    required this.isFirstTime,
    required this.visibleProducts,
    required this.isLoadingMore,
    required this.isSearching,
    required this.isRemoteResult,
    this.apiSearchedProducts = const [], // default خالی

  });

  AddOrderState copyWith({
    AddOrderStatus? newAddOrderStatus,
    AddOrderCardProductStatus? newAddOrderCardProductStatus,
    AddOrderSetOrderStatus? newAddOrderSetOrderStatus,
    Map<int, int>? newCount,
    Map<int, bool>? newIsFirstTime,
    List<ProductEntity>? newVisibleProducts,
    bool? newIsLoadingMore,
    bool? newIsSearching,
    bool? newIsRemoteResult,
    List<ProductEntity>? newApiSearchedProducts, // ✅ اضافه شد

  }) {
    return AddOrderState(
      addOrderStatus: newAddOrderStatus ?? addOrderStatus,
      addOrderCardProductStatus:
      newAddOrderCardProductStatus ?? addOrderCardProductStatus,
      addOrderSetOrderStatus:
      newAddOrderSetOrderStatus ?? addOrderSetOrderStatus,
      count: newCount ?? count,
      isFirstTime: newIsFirstTime ?? isFirstTime,
      visibleProducts: newVisibleProducts ?? visibleProducts,
      isLoadingMore: newIsLoadingMore ?? isLoadingMore,
      isSearching: newIsSearching ?? isSearching,
      isRemoteResult: newIsRemoteResult ?? isRemoteResult,
      apiSearchedProducts: newApiSearchedProducts ?? apiSearchedProducts, // ✅

    );
  }

  @override
  List<Object?> get props => [
    addOrderStatus,
    addOrderCardProductStatus,
    addOrderSetOrderStatus,
    count,
    isFirstTime,
    visibleProducts,
    isLoadingMore,
    isSearching,
    isRemoteResult,
    apiSearchedProducts, // ✅ اضافه شد

  ];
}

