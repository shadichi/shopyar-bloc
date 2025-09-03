part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}


class LoadOrdersData extends OrdersEvent{
  bool isSearch;
  String search;
  bool isFilter;
  String perPage;
  String status;
  bool isLoadMore;
  LoadOrdersData(this.isSearch, this.search,this.isFilter, this.perPage, this.status,
      {this.isLoadMore = false});
}
class RefreshOrdersData extends OrdersEvent {
  final Completer<void>? completer;
  RefreshOrdersData([this.completer]);
}

class ShowFilter extends OrdersEvent{
  bool showFilter;
  ShowFilter(this.showFilter);
}
class ShowFilterOff extends OrdersEvent{
  bool showFilter;
  ShowFilterOff(this.showFilter);
}

class EditStatus extends OrdersEvent{
  OrdersEditStatus ordersEditStatus;
  EditStatus(this.ordersEditStatus);
}





