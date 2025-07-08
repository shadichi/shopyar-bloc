import 'package:shapyar_bloc/core/params/selected_products-params.dart';

import '../../features/feature_add_edit_order/domain/entities/add_order_orders_entity.dart';
import '../../features/feature_add_edit_order/domain/entities/add_order_product_entity.dart';

class AddOrderGetSelectedProductsParams {
  final AddOrderOrdersEntity addOrderOrdersEntity;//انتیتی سفارشات
  final List<AddOrderProductEntity> products;//انتیتی محصولات
  final SelectedProductsParams selected;//پارامز محصول انتخاب شده

  const AddOrderGetSelectedProductsParams({
    required this.addOrderOrdersEntity,
    required this.products,
    required this.selected,
  });
}
