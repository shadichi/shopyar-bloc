import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/features/feature_home/domain/repository/home_repository.dart';

import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/add_product_data_state.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../feature_log_in/domain/entities/login_entity.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../entities/add_order_product_entity.dart';
import '../repository/add_product_repository.dart';

class SubmitProductUseCase implements UseCase<AddProductDataState, InfParams>{
  final AddProductRepository _productRepository;
  SubmitProductUseCase(this._productRepository);

  @override
  Future<AddProductDataState> call(InfParams productsParams) {
    return _productRepository.submitProduct();
  }

}