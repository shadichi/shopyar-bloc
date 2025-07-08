import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/repository/orders_repository.dart';

import '../../../../core/params/orders_edit_status.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';

class EditOrdersStatusUseCase implements UseCase<DataState, OrdersEditStatus>{
  final OrdersRepository ordersRepository;
  EditOrdersStatusUseCase(this.ordersRepository);

  @override
  Future<DataState> call(OrdersEditStatus ordersEditStatus) {
    return ordersRepository.editStatus(ordersEditStatus);
  }

}