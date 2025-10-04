import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/features/feature_home/domain/repository/home_repository.dart';

import '../../../../core/params/add_order_data_state.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../feature_log_in/domain/entities/login_entity.dart';
import '../entities/add_order_data_entity.dart';
import '../entities/add_order_product_entity.dart';
import '../repository/add_order_repository.dart';

class AddOrderSetOrderUseCase implements UseCase<bool, SetOrderParams>{
  final AddOrderRepository _addOrderRepository;
  AddOrderSetOrderUseCase(this._addOrderRepository);

  @override
  Future<bool> call(SetOrderParams setOrderParams) {
    return _addOrderRepository.AddOrderSetOrder(setOrderParams);
  }

}