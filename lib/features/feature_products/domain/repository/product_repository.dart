
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/core/resources/data_state.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_log_in/data/data_source/remote/api_provider.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository{

  Future<ProductsParams> getString();

  Future<OrderDataState<ProductEntity>> getProducts(ProductsParams productsParams);
}