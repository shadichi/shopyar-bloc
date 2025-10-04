import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/features/feature_home/domain/repository/home_repository.dart';

import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../feature_log_in/domain/entities/login_entity.dart';
import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class GetProductsUseCase implements UseCase<OrderDataState<ProductEntity>, ProductsParams>{
  final ProductRepository _productRepository;
  GetProductsUseCase(this._productRepository);

  @override
  Future<OrderDataState<ProductEntity>> call(ProductsParams productsParams) {
    return _productRepository.getProducts(productsParams);
  }

}