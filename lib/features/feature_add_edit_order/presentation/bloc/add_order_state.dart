part of 'add_order_bloc.dart';

class AddOrderState extends Equatable {
  final AddOrderStatus addOrderStatus;
  final AddOrderCardProductStatus addOrderCardProductStatus;
  final AddOrderSetOrderStatus addOrderSetOrderStatus;
  final Map<int, int> count;
  final Map<int, bool> isFirstTime;

  // 👇 اضافه کن
  final List<ProductEntity> visibleProducts;

  const AddOrderState({
    required this.addOrderStatus,
    required this.addOrderCardProductStatus,
    required this.addOrderSetOrderStatus,
    required this.count,
    required this.isFirstTime,
    required this.visibleProducts, // 👈
  });

  AddOrderState copyWith({
    AddOrderStatus? newAddOrderStatus,
    AddOrderCardProductStatus? newAddOrderCardProductStatus,
    AddOrderSetOrderStatus? newAddOrderSetOrderStatus,
    Map<int, int>? newCount,
    Map<int, bool>? newIsFirstTime,
    List<ProductEntity>? newVisibleProducts, // 👈
  }) {
    return AddOrderState(
      addOrderStatus: newAddOrderStatus ?? addOrderStatus,
      addOrderCardProductStatus:
      newAddOrderCardProductStatus ?? addOrderCardProductStatus,
      addOrderSetOrderStatus:
      newAddOrderSetOrderStatus ?? addOrderSetOrderStatus,
      count: newCount ?? count,
      isFirstTime: newIsFirstTime ?? isFirstTime,
      visibleProducts: newVisibleProducts ?? visibleProducts, // 👈
    );
  }

  @override
  List<Object?> get props => [
    addOrderStatus,
    addOrderCardProductStatus,
    addOrderSetOrderStatus,
    count,
    isFirstTime,
    visibleProducts, // 👈
  ];
}

