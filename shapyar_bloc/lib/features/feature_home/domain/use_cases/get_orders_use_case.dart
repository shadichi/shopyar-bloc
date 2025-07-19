import 'package:shapyar_bloc/features/feature_home/domain/repository/home_repository.dart';

import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../feature_log_in/domain/entities/login_entity.dart';
import '../entities/orders_entity.dart';

class GetOrdersUseCase implements UseCase<OrderDataState<OrdersEntity>, OrdersParams>{
  final HomeRepository _homeRepository;
  GetOrdersUseCase(this._homeRepository);

  @override
  Future<OrderDataState<OrdersEntity>> call(OrdersParams ordersParams) {
    return _homeRepository.getOrders(ordersParams);
  }

}