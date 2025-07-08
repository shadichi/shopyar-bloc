import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/orders_edit_status.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';

abstract class OrdersRepository{

  Future<OrderDataState<OrdersEntity>> getOrders(OrdersParams ordersParams);

  Future<DataState> editStatus(OrdersEditStatus ordersEditStatus);

}