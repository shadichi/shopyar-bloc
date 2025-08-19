part of 'orders_bloc.dart';

class OrdersState extends Equatable{
  final OrdersStatus ordersStatus;
  final bool showFilter;
  final OrdersStatus editStatus;
  final bool isLoadingMore;
  const OrdersState({required this.ordersStatus, required this.showFilter, required this.editStatus, required this.isLoadingMore});

  OrdersState copyWith({
  OrdersStatus? newOrdersStatus,
    bool? newShowFilter,
    OrdersStatus? newEditStatus,
    bool? newIsLoadingMore,
}){
    return OrdersState(ordersStatus: newOrdersStatus?? ordersStatus, showFilter: newShowFilter?? showFilter, editStatus: newEditStatus?? editStatus, isLoadingMore: newIsLoadingMore??isLoadingMore);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [ordersStatus, showFilter, editStatus, isLoadingMore ];
}