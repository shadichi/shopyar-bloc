import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/features/feature_home/domain/repository/home_repository.dart';

import '../../../../core/params/add_order_data_state.dart';
import '../../../../core/params/add_order_get_selected_products_params.dart';
import '../../../../core/params/add_order_products_card.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/params/selected_products-params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../feature_log_in/domain/entities/login_entity.dart';
import '../entities/add_order_orders_entity.dart';
import '../entities/add_order_product_entity.dart';
import '../repository/add_order_repository.dart';

class AddOrderGetSelectedProductsUseCase implements UseCase<AddOrderProductsCard<AddOrderOrdersEntity>, AddOrderGetSelectedProductsParams>{
  final AddOrderRepository _productRepository;
  AddOrderGetSelectedProductsUseCase(this._productRepository);

  @override
  Future<AddOrderProductsCard<AddOrderOrdersEntity>> call(AddOrderGetSelectedProductsParams addOrderGetSelectedProductsParams) {
    return _productRepository.getSelectedProducts(addOrderGetSelectedProductsParams);
  }

}