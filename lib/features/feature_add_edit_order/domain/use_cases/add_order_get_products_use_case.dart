import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/features/feature_home/domain/repository/home_repository.dart';

import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../feature_log_in/domain/entities/login_entity.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../entities/add_order_product_entity.dart';
import '../repository/add_order_repository.dart';

class AddOrderGetProductsUseCase implements UseCase<OrderDataState<ProductEntity>, ProductsParams>{
  final AddOrderRepository _productRepository;
  AddOrderGetProductsUseCase(this._productRepository);

  @override
  Future<OrderDataState<ProductEntity>> call(ProductsParams productsParams) {
    return _productRepository.getOrderProducts(productsParams);
  }

}