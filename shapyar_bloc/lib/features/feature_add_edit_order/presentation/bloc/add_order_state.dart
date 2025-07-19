part of 'add_order_bloc.dart';

class AddOrderState extends Equatable {
  final AddOrderStatus addOrderStatus;
  final AddOrderCardProductStatus addOrderCardProductStatus;
  final AddOrderSetOrderStatus addOrderSetOrderStatus;
  final Map<int, int> count;
  final Map<int, bool> isFirstTime;

  const AddOrderState(
      {required this.addOrderStatus,
      required this.addOrderCardProductStatus,
      required this.addOrderSetOrderStatus,
      required this.count,
        required this.isFirstTime
      });

  AddOrderState copyWith(
      {AddOrderStatus? newAddOrderStatus,
      AddOrderCardProductStatus? newAddOrderCardProductStatus,
        AddOrderSetOrderStatus? newAddOrderSetOrderStatus,
        Map<int, int>? newCount,
        Map<int, bool>? newIsFirstTime
      }) {
    return AddOrderState(
        addOrderStatus: newAddOrderStatus ?? addOrderStatus,
        addOrderCardProductStatus:
        newAddOrderCardProductStatus ?? addOrderCardProductStatus,
        addOrderSetOrderStatus: newAddOrderSetOrderStatus?? addOrderSetOrderStatus,
      count: newCount?? count,
      isFirstTime: newIsFirstTime?? isFirstTime


    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [addOrderStatus,addOrderCardProductStatus ,addOrderSetOrderStatus, count, isFirstTime];
}
