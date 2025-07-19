part of 'orders_bloc.dart';

class OrdersState extends Equatable{
  final OrdersStatus ordersStatus;
  final bool showFilter;
  final OrdersStatus editStatus;
  const OrdersState({required this.ordersStatus, required this.showFilter, required this.editStatus});

  OrdersState copyWith({
  OrdersStatus? newOrdersStatus,
    bool? newShowFilter,
    OrdersStatus? newEditStatus,
}){
    return OrdersState(ordersStatus: newOrdersStatus?? ordersStatus, showFilter: newShowFilter?? showFilter, editStatus: newEditStatus?? ordersStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [ordersStatus, showFilter, editStatus ];
}