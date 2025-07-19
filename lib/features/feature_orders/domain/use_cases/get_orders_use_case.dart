import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/repository/orders_repository.dart';

import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';

class GetOrdersUseCase implements UseCase<OrderDataState<OrdersEntity>, OrdersParams>{
  final OrdersRepository ordersRepository;
  GetOrdersUseCase(this.ordersRepository);

  @override
  Future<OrderDataState<OrdersEntity>> call(OrdersParams ordersParams) {
    return ordersRepository.getOrders(ordersParams);
  }

}