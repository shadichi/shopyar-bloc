
import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/core/resources/data_state.dart';

import '../../../../core/params/add_order_data_state.dart';
import '../../../../core/params/add_order_get_selected_products_params.dart';
import '../../../../core/params/add_order_products_card.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/params/selected_products-params.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_log_in/data/data_source/remote/api_provider.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../entities/add_order_data_entity.dart';
import '../entities/add_order_orders_entity.dart';
import '../entities/add_order_product_entity.dart';

abstract class AddOrderRepository{


  Future<OrderDataState<ProductEntity>> getOrderProducts(ProductsParams productsParams);


  Future<AddOrderProductsCard<AddOrderOrdersEntity>> getSelectedProducts(AddOrderGetSelectedProductsParams addOrderGetSelectedProductsParams);

  Future<bool> AddOrderSetOrder(SetOrderParams setOrderParams);
}